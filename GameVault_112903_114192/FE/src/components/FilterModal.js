import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './FilterModal.css';

function FilterModal({ onClose, onApplyFilters }) {
    const defaultFilters = {
        genre: '',
        developer: '',
        publisher: '',
        filterModeRating: '>',
        rating: '',
        platform: '',
        filterModeReviews: '>',
        reviews: '',
        filterModeYear: '>',
        year: '',
        month: '',
        day: '',
        tooltipTextRating: 'Show games with rating greater than',
        tooltipTextReviews: 'Show games with more reviews than',
        tooltipTextYear: 'Show games released at least in'
    };

    const [filters, setFilters] = useState({ ...defaultFilters });
    const [filterModes, setFilterModes] = useState({
        filterModeRating: 'greater than or equal to',
        filterModeReviews: 'greater than or equal to',
        filterModeYear: 'greater than or equal to'
    });

    const [genres, setGenres] = useState([]);
    const [developers, setDevelopers] = useState([]);
    const [publishers, setPublishers] = useState([]);
    const [platforms, setPlatforms] = useState([]);

    const [showConfirmationModal, setShowConfirmationModal] = useState(false);

    const fetchData = async () => {
        try {
            const genresResponse = await axios.get('http://localhost:5000/api/GameVault_Genero');
            const developersResponse = await axios.get('http://localhost:5000/api/nomeDesenvolvedora');
            const publishersResponse = await axios.get('http://localhost:5000/api/nomeEditora');
            const platformsResponse = await axios.get('http://localhost:5000/api/GameVault_Plataforma');

            setGenres(genresResponse.data.map(item => item.Nome));
            setDevelopers(developersResponse.data.map(item => item.NomeDesenvolvedora));
            setPublishers(publishersResponse.data.map(item => item.NomeEditora));
            setPlatforms(platformsResponse.data.map(item => item.Nome));
        } catch (error) {
            console.error('Error fetching filter data:', error);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFilters({ ...filters, [name]: value });
    };

    const handleRatingChange = (e) => {
        const value = e.target.value;
        if (value === '' || (/^\d*\.?\d*$/.test(value) && Number(value) >= 0 && Number(value) <= 5)) {
            setFilters({ ...filters, rating: value });
        }
    };

    const handleReviewChange = (e) => {
        const value = e.target.value;
        if (value === '' || (/^\d+$/.test(value) && Number(value) >= 0)) {
            setFilters({ ...filters, reviews: value });
        }
    };

    const checkDate = (date) => {
        if (date === '') return true;
        return /^\d{1,2}\/\d{1,2}\/\d{4}$|^\d{1,2}\/\d{4}$|^\d{4}$/.test(date);
    };

    const applyFilters = () => {
        if (!checkDate(filters.year)) {
            alert('Invalid date format. Please use dd/mm/yyyy, mm/yyyy or yyyy.');
            return;
        }
        const changedFilters = getChangedFilters();
        if (Object.keys(changedFilters).length > 0) {
            setShowConfirmationModal(true);
        } else {
            alert('Please select filters to apply.');
        }
    };

    const confirmApplyFilters = () => {
        const parsedFilters = parseDateFilter(filters);
        onApplyFilters(parsedFilters);
        onClose();
        setShowConfirmationModal(false);
    };

    const toggleFilterModeRating = () => {
        const newFilterMode = filters.filterModeRating === '>' ? '<' : '>';
        const newFilterModeText = newFilterMode === '>' ? 'greater than or equal to' : 'less than';
        const newTooltipText = newFilterMode === '>' ? 'Show games with rating greater than' : 'Show games with rating less than';
        setFilters({ ...filters, filterModeRating: newFilterMode, tooltipTextRating: newTooltipText });
        setFilterModes({ ...filterModes, filterModeRating: newFilterModeText });
    };

    const toggleFilterModeReviews = () => {
        const newFilterMode = filters.filterModeReviews === '>' ? '<' : '>';
        const newFilterModeText = newFilterMode === '>' ? 'greater than or equal to' : 'less than';
        const newTooltipText = newFilterMode === '>' ? 'Show games with more reviews than' : 'Show games with fewer reviews than';
        setFilters({ ...filters, filterModeReviews: newFilterMode, tooltipTextReviews: newTooltipText });
        setFilterModes({ ...filterModes, filterModeReviews: newFilterModeText });
    };

    const toggleFilterModeYear = () => {
        const newFilterMode = filters.filterModeYear === '>' ? '<' : '>';
        const newFilterModeText = newFilterMode === '>' ? 'greater than or equal to' : 'less than';
        const newTooltipText = newFilterMode === '>' ? 'Show games released at least in' : 'Show games released before';
        setFilters({ ...filters, filterModeYear: newFilterMode, tooltipTextYear: newTooltipText });
        setFilterModes({ ...filterModes, filterModeYear: newFilterModeText });
    };

    const getChangedFilters = () => {
        return Object.keys(filters).reduce((changedFilters, key) => {
            if (filters[key] !== defaultFilters[key]) {
                changedFilters[key] = filters[key];
            }
            return changedFilters;
        }, {});
    };

    const parseDateFilter = (filters) => {
        const dateParts = filters.year.split('/');
        const parsedFilters = { ...filters };

        if (dateParts.length === 1) {
            parsedFilters.year = dateParts[0];
            parsedFilters.month = '';
            parsedFilters.day = '';
        } else if (dateParts.length === 2) {
            parsedFilters.year = dateParts[1];
            parsedFilters.month = dateParts[0];
            parsedFilters.day = '';
        } else if (dateParts.length === 3) {
            parsedFilters.year = dateParts[2];
            parsedFilters.month = dateParts[1];
            parsedFilters.day = dateParts[0];
        }

        return parsedFilters;
    };

    const stringifyChangedFilters = () => {
        const changedFilters = getChangedFilters();
        return Object.entries(changedFilters)
            .map(([key, value]) => {
                if (key === 'filterModeRating' || key === 'filterModeReviews' || key === 'filterModeYear' || key === 'tooltipTextRating' || key === 'tooltipTextReviews' || key === 'tooltipTextYear') {
                    return null;
                }
                if (key === 'rating' || key === 'reviews' || key === 'year') {
                    const displayKey = key === 'year' ? 'Release Date' : key.charAt(0).toUpperCase() + key.slice(1);
                    return `${displayKey}: ${filterModes[`filterMode${key.charAt(0).toUpperCase() + key.slice(1)}`]} ${value}`;
                }
                return `${key.charAt(0).toUpperCase() + key.slice(1)}: ${value}`;
            })
            .filter(item => item !== null)
            .join('\n');
    };

    const clearFilters = () => {
        setFilters({ ...defaultFilters });
    };

    const handleOverlayClick = (event) => {
        if (event.target === event.currentTarget) {
            onClose();
        }
    };

    return (
        <div className="modal" onClick={handleOverlayClick}>
            <div className="modal-content">
            <button className="absolute top-2 right-2 text-2xl" onClick={onClose}>&times;</button>
                <h2>Filter Games</h2>
                <div className='filter'>
                    <label>Genre:</label>
                    <select name="genre" value={filters.genre} onChange={handleInputChange} className='genre-selection'>
                        <option value="">All</option>
                        {genres.map(genre => <option key={genre} value={genre}>{genre}</option>)}
                    </select>
                </div>
                <div className='filter'>
                    <label>Developer:</label>
                    <select name="developer" value={filters.developer} onChange={handleInputChange} className='developer-selection'>
                        <option value="">All</option>
                        {developers.map(developer => <option key={developer} value={developer}>{developer}</option>)}
                    </select>
                </div>
                <div className='filter'>
                    <label>Publisher:</label>
                    <select name="publisher" value={filters.publisher} onChange={handleInputChange} className='publisher-selection'>
                        <option value="">All</option>
                        {publishers.map(publisher => <option key={publisher} value={publisher}>{publisher}</option>)}
                    </select>
                </div>
                <div className='filter'>
                    <label>Rating:</label>
                    <button onClick={toggleFilterModeRating} className='toggle-button' title={filters.tooltipTextRating}>{filters.filterModeRating}</button>
                    <input type="text" name="rating" value={filters.rating} onChange={handleRatingChange}
                        placeholder="0-5" className='rating-input' />
                </div>
                <div className='filter'>
                    <label>Platform:</label>
                    <select name="platform" value={filters.platform} onChange={handleInputChange} className='platform-selection'>
                        <option value="">All</option>
                        {platforms.map(platform => <option key={platform} value={platform}>{platform}</option>)}
                    </select>
                </div>
                <div className='filter'>
                    <label>Number of Reviews:</label>
                    <button onClick={toggleFilterModeReviews} className='toggle-button' title ={filters.tooltipTextReviews}>{filters.filterModeReviews}</button>
                    <input type="text" name="reviews" value={filters.reviews} onChange={handleReviewChange}
                        placeholder="Ex.:1500" className='rating-input'/>
                </div>
                <div className='filter'>
                    <label>Release Date:</label>
                    <button onClick={toggleFilterModeYear} className='toggle-button' title={filters.tooltipTextYear}>{filters.filterModeYear}</button>
                    <input type="text" name="year" value={filters.year} onChange={handleInputChange}
                        placeholder="Ex.:dd/mm/yyyy or mm/yyyy or yyyy" className='rating-input'/>
                </div>
                <button className='apply-button' onClick={applyFilters}>Apply Filters</button>
                <button className='clearfilter-button' onClick={clearFilters}>Clear Filters</button>
            </div>
            {showConfirmationModal && (
                <div className="confirmation-modal">
                    <div className="confirmation-modal-content">
                        <h2>Confirmation</h2>
                        <p>These filters will be applied:</p>
                        <pre>{stringifyChangedFilters()}</pre>
                        <button onClick={confirmApplyFilters} className='confirm-buttons'>OK!</button>
                    </div>
                </div>
            )}
        </div>
    );
}

export default FilterModal;