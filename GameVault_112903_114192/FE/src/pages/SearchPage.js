import { faFilter, faTimes } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import FilterModal from '../components/FilterModal';
import Footer from '../components/Footer';
import Navbar from '../components/Navbar';
import './SearchPage.css';

function SearchPage() {
    const [searchInput, setSearchInput] = useState('');
    const [games, setGames] = useState([]);
    const [filteredGames, setFilteredGames] = useState([]);
    const [isSearching, setIsSearching] = useState(false);
    const [showAllGames, setShowAllGames] = useState(false);
    const [showFilterModal, setShowFilterModal] = useState(false);
    const [sortOption, setSortOption] = useState('default');
    const [filters, setFilters] = useState({
        genre: '',
        developer: '',
        publisher: '',
        platform: '',
        filterModeRating: '>',
        rating: '',
        filterModeReviews: '>',
        reviews: '',
        filterModeYear: '>',
        year: ''
    });

    const location = useLocation();

    useEffect(() => {
        const savedFilters = JSON.parse(sessionStorage.getItem('filters'));
        const savedSortOption = sessionStorage.getItem('sortOption');
        const queryParams = new URLSearchParams(location.search);
        const query = queryParams.get('query');

        if (savedFilters) {
            setFilters(savedFilters);
            if (query) {
                setSearchInput(query);
                setIsSearching(true);
                searchGames(query, savedFilters, savedSortOption);
                setShowAllGames(true);
            } else {
                applyFiltersOnly(savedFilters, savedSortOption);
                setShowAllGames(true);
            }
        } else if (query) {
            setSearchInput(query);
            setIsSearching(true);
            searchGames(query);
            setShowAllGames(true);
        } else {
            fetchRandomGames();
        }

        if (savedSortOption) {
            setSortOption(savedSortOption);
        }
    }, [location.search]);

    const fetchRandomGames = async () => {
        try {
            const response = await axios.get('http://localhost:5000/api/randomGames');
            setGames(response.data);
            setFilteredGames(response.data);
            setShowAllGames(false);
        } catch (error) {
            console.error('Error fetching random games:', error);
        }
    };

    const fetchGames = async () => {
        try {
            const response = await axios.get('http://localhost:5000/api/infoJogo');
            const allGames = response.data;
            setGames(allGames);
            setFilteredGames(allGames);
        } catch (error) {
            console.error('Error fetching games:', error);
        }
    };

    const handleChange = (e) => {
        const { value } = e.target;
        setSearchInput(value);
        setIsSearching(value.trim() !== '');
        setShowAllGames(true);

        const queryParams = new URLSearchParams(location.search);
        queryParams.set('query', value);
        window.history.replaceState({}, '', `${window.location.pathname}?${queryParams.toString()}`);

        if (!value.trim()) {
            if (areFiltersApplied()) {
                applyFiltersOnly();
            } else {
                fetchRandomGames();
            }
        } else {
            searchGames(value);
            setShowAllGames(true);
        }
    };

    const areFiltersApplied = () => {
        return Object.keys(filters).some(key => {
            if (key === 'filterModeRating' || key === 'filterModeReviews' || key === 'filterModeYear' || key === 'tooltipTextRating' || key === 'tooltipTextReviews' || key === 'tooltipTextYear') {
                return false;
            }
            return filters[key] !== '';
        });
    };

    const applyFiltersOnly = async (filtersParam = filters, sortOptionParam = sortOption) => {
        try {
            const response = await axios.post('http://localhost:5000/api/filterGames', filtersParam);
            let filteredGames = response.data;

            if (sortOptionParam !== 'default') {
                filteredGames = await sortGames(filteredGames, sortOptionParam);
            }

            setGames(filteredGames);
            setFilteredGames(filteredGames);
        } catch (error) {
            console.error('Error applying filters:', error);
        }
    };

    const searchGames = async (query, filtersParam = filters, sortOptionParam = sortOption) => {
        const queryParams = new URLSearchParams({
            query,
            ...filtersParam
        });

        try {
            const response = await axios.get(`http://localhost:5000/api/searchGames?${queryParams.toString()}`);
            let searchedGames = response.data;

            if (sortOptionParam !== 'default') {
                searchedGames = await sortGames(searchedGames, sortOptionParam);
            }

            setGames(searchedGames);
            setFilteredGames(searchedGames);
        } catch (error) {
            console.error('Error searching games:', error);
        }
    };

    const clearSearch = () => {
        setSearchInput('');
        setIsSearching(false);
        setShowAllGames(false);
        setSortOption('default');
        setFilters({
            genre: '',
            developer: '',
            publisher: '',
            platform: '',
            filterModeRating: '>',
            rating: '',
            filterModeReviews: '>',
            reviews: '',
            filterModeYear: '>',
            year: '',
            month: '',
            day: ''
        });
        sessionStorage.removeItem('filters');
        sessionStorage.removeItem('sortOption');
        fetchRandomGames();
        const queryParams = new URLSearchParams(location.search);
        queryParams.delete('query');
        window.history.replaceState({}, '', `${window.location.pathname}?${queryParams.toString()}`);
    };

    const handleSeeAllGames = () => {
        fetchGames();
        setShowAllGames(true);
    };

    const toggleFilterModal = () => {
        setShowFilterModal(!showFilterModal);
    };

    const handleApplyFilters = async (filters) => {
        setFilters(filters);
        sessionStorage.setItem('filters', JSON.stringify(filters));

        const queryParams = new URLSearchParams({
            ...filters
        });

        if (searchInput) {
            queryParams.set('query', searchInput);
        }

        try {
            const endpoint = searchInput
                ? `http://localhost:5000/api/searchGames?${queryParams.toString()}`
                : `http://localhost:5000/api/filterGames`;

            const response = searchInput
                ? await axios.get(endpoint)
                : await axios.post(endpoint, filters);

            let updatedGames = response.data;

            if (sortOption !== 'default') {
                updatedGames = await sortGames(updatedGames, sortOption);
            }

            setGames(updatedGames);
            setFilteredGames(updatedGames);
            setShowAllGames(true);
        } catch (error) {
            console.error('Error applying filters:', error);
        }
    };

    const handleSortChange = async (e) => {
        const { value } = e.target;
        setSortOption(value);
        sessionStorage.setItem('sortOption', value);

        const ids = filteredGames.map(game => game.ID);
        if (ids.length === 0) return;

        if (value === 'default') {
            setFilteredGames(games);
            return;
        }

        let updatedFilters = { ...filters };

        if (value.includes('year')) {
            updatedFilters.year = true;
        } else if (value.includes('reviews')) {
            updatedFilters.reviews = true;
        } else if (value.includes('rating')) {
            updatedFilters.rating = true;
        }

        try {
            const response = await axios.post(`http://localhost:5000/api/sortGames`, {
                ids,
                option: value
            });
            setFilteredGames(response.data);
        } catch (error) {
            console.error('Error sorting games:', error);
        }
    };

    const sortGames = async (games, sortOptionParam = sortOption) => {
        const ids = games.map(game => game.ID);

        if (ids.length === 0) return games;

        try {
            const response = await axios.post(`http://localhost:5000/api/sortGames`, {
                ids,
                option: sortOptionParam
            });
            return response.data;
        } catch (error) {
            console.error('Error sorting games:', error);
            return games;
        }
    };

    const shouldShowDetail = (detail) => {
        return filters[detail] !== '' || sortOption.includes(detail);
    };

    function formatRating(rating) {
        return Number.isInteger(rating) ? rating : rating.toFixed(2);
      }

    return (
        <div>
            <Navbar />
            <main className="page-content">
                <div className="search-container">
                    <input
                        type="search"
                        placeholder="Search here"
                        onChange={handleChange}
                        value={searchInput}
                        className="search-input"
                    />
                    <button className="filters-button" onClick={toggleFilterModal}>
                        <FontAwesomeIcon icon={faFilter} />
                    </button>
                    <button className="clear-button" onClick={clearSearch}>
                        <FontAwesomeIcon icon={faTimes} />
                    </button>
                    <select onChange={handleSortChange} value={sortOption} className="sort-dropdown">
                        <option value="default">Order by</option>
                        <option value="alphabetical-az">Alphabetical A-Z</option>
                        <option value="alphabetical-za">Alphabetical Z-A</option>
                        <option value="year-more-recent">Release Date: More Recent to Less</option>
                        <option value="year-less-recent">Release Date: Less Recent to More</option>
                        <option value="reviews-more">Number of Reviews: More to Less</option>
                        <option value="reviews-less">Number of Reviews: Less to More</option>
                        <option value="rating-more">Rating: More to Less</option>
                        <option value="rating-less">Rating: Less to More</option>
                    </select>
                </div>
                {showFilterModal && (
                    <FilterModal
                        onClose={toggleFilterModal}
                        onApplyFilters={handleApplyFilters}
                    />
                )}
            </main>
            <div className="page-content">
                {isSearching ? (
                    <h2>Search Results For: {searchInput}</h2>
                ) : (
                    <h2>Find Games</h2>
                )}
                <div className="games-container">
                    {filteredGames.length > 0 ? (
                        filteredGames.map((game) => (
                            <Link to={`/game/${game.ID}`} key={game.ID} className="game-card">
                                <img src={game.Imagem} alt={game.Nome} className="game-image" />
                                <div className="game-info">
                                    <p className="game-name">{game.Nome}</p>
                                    {shouldShowDetail('genre') && <p className="game-genre">Genre: {game.Genero}</p>}
                                    {shouldShowDetail('developer') && <p className="game-developer">Developer: {game.NomeDesenvolvedora}</p>}
                                    {shouldShowDetail('publisher') && <p className="game-publisher">Publisher: {game.NomeEditora}</p>}
                                    {shouldShowDetail('rating') && <p className="game-rating">Rating: {formatRating(game.Rating)}</p>}
                                    {shouldShowDetail('platform') && <p className="game-platform">Platform: {game.NomePlataforma}</p>}
                                    {shouldShowDetail('reviews') && <p className="game-reviews">Reviews: {game.Num_Reviews}</p>}
                                    {shouldShowDetail('year') && <p className="game-year">Release Date: {new Date(game.Data_lancamento).toLocaleDateString(undefined, { day: '2-digit', month: '2-digit', year: 'numeric' })}</p>}
                                </div>
                            </Link>
                        ))
                    ) : (
                        <div className='no-games'>
                            <p>No matching games found.</p>
                        </div>
                    )}
                </div>
                {!showAllGames && (
                    <button className="see-all-button" onClick={handleSeeAllGames}>See All Games</button>
                )}
            </div>
            <Footer />
        </div>
    );
}

export default SearchPage;