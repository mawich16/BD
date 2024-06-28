import { faTimes } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import Footer from '../components/Footer';
import Navbar from '../components/Navbar';
import './Companies.css';

function CompaniesPage() {
    const [searchInput, setSearchInput] = useState('');
    const [companies, setCompanies] = useState([]);
    const [isSearching, setIsSearching] = useState(false);
    const [sortedCompanies, setSortedCompanies] = useState([]);
    const [showAllCompanies, setShowAllCompanies] = useState(false);
    const [sortOption, setSortOption] = useState('default');
    const [secondarySearchInput, setSecondarySearchInput] = useState('');
    const [secondaryResults, setSecondaryResults] = useState([]);
    const [isSecondarySearching, setIsSecondarySearching] = useState(false);

    const location = useLocation();

    useEffect(() => {
        const savedSortOption = sessionStorage.getItem('sortOption');
        const queryParams = new URLSearchParams(location.search);
        const query = queryParams.get('query');

        if (query) {
            setSearchInput(query);
            setIsSearching(true);
            setShowAllCompanies(true);
        } else {
            fetchRandomCompanies();
        }

        if (savedSortOption) {
            setSortOption(savedSortOption);
        }
    }, [location.search]);

    const fetchRandomCompanies = async () => {
        try {
            const response = await axios.get('http://localhost:5000/api/randomCompanies');
            setCompanies(response.data);
            setSortedCompanies(response.data);
            setShowAllCompanies(false);
        } catch (error) {
            console.error('Error fetching random companies:', error.message);
        }
    };

    const fetchCompanies = async () => {
        try {
            const response = await axios.get('http://localhost:5000/api/empresaInfo');
            const allCompanies = response.data;
            setCompanies(allCompanies);
            setSortedCompanies(allCompanies);
        } catch (error) {
            console.error('Error fetching companies:', error);
        }
    };

    const handleChange = (e) => {
        const { value } = e.target;
        setSearchInput(value);
        setIsSearching(value.trim() !== '');
        setShowAllCompanies(true);

        const queryParams = new URLSearchParams(location.search);
        queryParams.set('query', value);
        window.history.replaceState({}, '', `${window.location.pathname}?${queryParams.toString()}`);

        if (!value.trim()) {
            fetchRandomCompanies();
        } else {
            searchCompanies(value);
            setShowAllCompanies(true);
        }
    };

    const handleSecondaryChange = (e) => {
        const { value } = e.target;
        setSecondarySearchInput(value);
        setIsSecondarySearching(value.trim() !== '');

        if (!value.trim()) {
            setSecondaryResults([]);
        } else {
            searchSecondaryCompanies(value);
        }
    };

    const searchCompanies = async (query, sortOptionParam = sortOption) => {
        const queryParams = new URLSearchParams({ query });

        try {
            const response = await axios.get(`http://localhost:5000/api/searchCompanies?${queryParams.toString()}`);
            let searchedCompanies = response.data;

            if (sortOptionParam !== 'default') {
                searchedCompanies = await sortCompanies(searchedCompanies, sortOptionParam);
            }

            setCompanies(searchedCompanies);
            setSortedCompanies(searchedCompanies);
        } catch (error) {
            console.error('Error searching companies:', error);
        }
    };

    const searchSecondaryCompanies = async (query, sortOptionParam = sortOption) => {
        const queryParams = new URLSearchParams({ query });

        try {
            const response = await axios.get(`http://localhost:5000/api/searchSecondaryCompanies?${queryParams.toString()}`);
            let searchedSecondaryCompanies = response.data;

            if (sortOptionParam !== 'default') {
                searchedSecondaryCompanies = await sortCompanies(searchedSecondaryCompanies, sortOptionParam);
            }

            setCompanies(searchedSecondaryCompanies);
            setSortedCompanies(searchedSecondaryCompanies);
        } catch (error) {
            console.error('Error searching secondary companies:', error);
        }
    };

    const clearSearch = () => {
        setSearchInput('');
        setIsSearching(false);
        setShowAllCompanies(false);
        setSortOption('default');
        sessionStorage.removeItem('sortOption');
        fetchRandomCompanies();
        const queryParams = new URLSearchParams(location.search);
        queryParams.delete('query');
        window.history.replaceState({}, '', `${window.location.pathname}?${queryParams.toString()}`);

        // Clear secondary search
        setSecondarySearchInput('');
        setIsSecondarySearching(false);
        setSecondaryResults([]);
    };

    const handleSeeAllCompanies = () => {
        fetchCompanies();
        setShowAllCompanies(true);
    };

    const handleSortChange = async (e) => {
        const { value } = e.target;
        setSortOption(value);
        sessionStorage.setItem('sortOption', value);
        const ids = companies.map(company => `${company.ID}-${company.type}`);

        if (value === 'default') {
            setSortedCompanies(companies);
            return;
        }
    
        try {
            const response = await axios.post(`http://localhost:5000/api/sortCompanies`, {
                ids,
                option: value
            });
            setSortedCompanies(response.data);
        } catch (error) {
            console.error('Error sorting companies:', error.message);
        }
    };

    const sortCompanies = async (companies, sortOptionParam = sortOption) => {
        const ids = companies.map(company => `${company.ID}-${company.type}`);

        if (ids.length === 0) return companies;

        try {
            const response = await axios.post(`http://localhost:5000/api/sortCompanies`, {
                ids,
                option: sortOptionParam
            });
            return response.data;
        } catch (error) {
            console.error('Error sorting companies:', error);
            return companies;
        }
    };

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
                    <input
                        type="search"
                        placeholder="Search here by game"
                        onChange={handleSecondaryChange}
                        value={secondarySearchInput}
                        className="search-input secondary-search-input"
                    />
                    <button className="clear-button" onClick={clearSearch}>
                        <FontAwesomeIcon icon={faTimes} />
                    </button>
                    <select onChange={handleSortChange} value={sortOption} className="sort-dropdown">
                        <option value="default">Order by</option>
                        <option value="byEditors">Editor</option>
                        <option value="byDevelopers">Developers</option>
                        <option value="byPlataforma">Platforms</option>
                        <option value="byLoja">Stores</option>
                    </select>
                </div>
            </main>
            <div className="page-content">
                {(isSearching || isSecondarySearching) ? (
                    <h2>Search Results For: {searchInput} {secondarySearchInput && `${secondarySearchInput}`}</h2>
                ) : (
                    <h2>Find Companies</h2>
                )}
                <div className="companies-container">
                    {sortedCompanies.length > 0 ? (
                        sortedCompanies.map((company) => (
                            <Link to={`/companyDetails/${company.ID}/${company.type}`} key={`${company.ID}-${company.type}`} className="company-card">
                                <div className="company-info">
                                    <p className="company-name"> {company.Nome}</p>
                                    <p className="company-gameNum">Number of games: {company.numJogos}</p>
                                    <p className="company-location">Location: {company.Localizacao}</p>
                                    <p className="company-year">Year: {company.Ano_criacao}</p>
                                </div>
                            </Link>
                        ))
                    ) : (
                        <div className='no-companies'>
                            <p>No matching companies found.</p>
                        </div>
                    )}
                </div>
                {!showAllCompanies && (
                    <button className="see-all-button" onClick={handleSeeAllCompanies}>See All Companies</button>
                )}

                {isSecondarySearching && (
                    <div className="companies-container">
                        {secondaryResults.length > 0 ? (
                            secondaryResults.map((result) => (
                                <Link to={`/companyDetails/${result.ID}/${result.type}`} key={`${result.ID}-${result.type}`} className="company-card">
                                <div className="company-info">
                                    <p className="company-name"> {result.Nome}</p>
                                    <p className="company-gameNum">Number of games: {result.numJogos}</p>
                                    <p className="company-location">Location: {result.Localizacao}</p>
                                    <p className="company-year">Year: {result.Ano_criacao}</p>
                                </div>
                            </Link>
                            ))
                        ) : (
                            <p>No secondary search results found.</p>
                        )}
                    </div>
                )}
            </div>
            <Footer />
        </div>
    );
}

export default CompaniesPage;