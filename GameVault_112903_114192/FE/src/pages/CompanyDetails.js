import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import Footer from '../components/Footer';
import Navbar from '../components/Navbar';
import './CompanyDetails.css';

function CompanyDetails() {
    const { id, type } = useParams();
    const [companyData, setCompanyData] = useState([]);
    const [companyDetails, setCompanyDetails] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchCompanyData = async () => {
            try {
                const response = await axios.get(`http://localhost:5000/api/companyDetails/${id}/${type}`);
                setCompanyData(response.data);
                setLoading(false);
            } catch (error) {
                console.error('Error fetching company details:', error);
                setError(error);
                setLoading(false);
            }
        };

        const fetchCompanyDetails = async () => {
            try {
                const response = await axios.get(`http://localhost:5000/api/companyInfo/${id}/${type}`);
                setCompanyDetails(response.data[0]);
                setLoading(false);
            } catch (error) {
                console.error('Error fetching company info:', error);
                setError(error);
                setLoading(false);
            }
        };

        if (id && type) {
            fetchCompanyDetails();
            fetchCompanyData();
        } else {
            setLoading(false);
            setError(new Error('Invalid company ID or type'));
        }
    }, [id, type]);

    useEffect(() => {
        if (companyDetails) {
            console.log('Company Info:', companyDetails);
        }
    }, [companyDetails]);

    if (loading) {
        return <div>Loading...</div>;
    }

    if (error) {
        return <div>Error: {error.message}</div>;
    }

    return (
        <div>
            <Navbar />
            <main className="page-content">
                <div className="company-details-container">
                    {companyDetails ? (
                        <div>
                            <h1>{companyDetails.Nome}</h1>
                            <p>Location: {companyDetails.Localizacao}</p>
                            <p>Number of games: {companyDetails.numJogos}</p>
                            <p>Year of creation: {companyDetails.Ano_criacao}</p>
                        </div>
                    ) : (
                        <div>No company data available</div>
                    )}
                </div>
                <div className="games-section">
                    <h2>Games</h2>
                    {type === 'E' && companyData.length > 0 && (
                        <div>
                            <h3>Edited Games</h3>
                            <ul>
                                {companyData.map(game => (
                                    <Link to={`/game/${game.IdJogo}`} key={`${game.IdJogo}`}>
                                    <li key={game.IdJogo}>{game.NomeJogo}</li>
                                    </Link>
                                ))}
                            </ul>
                        </div>
                    )}

                    {type === 'D' && companyData.length > 0 && (
                        <div>
                            <h3>Developed Games</h3>
                            <ul>
                                {companyData.map(game => (
                                    <Link to={`/game/${game.IdJogo}`} key={`${game.IdJogo}`}>
                                    <li key={game.IdJogo}>{game.NomeJogo}</li>
                                    </Link>
                                ))}
                            </ul>
                        </div>
                    )}

                    {type === 'P' && companyData.length > 0 && (
                        <div>
                            <h3>Platform Games</h3>
                            <ul>
                                {companyData.map(game => (
                                    <Link to={`/game/${game.IdJogo}`} key={`${game.IdJogo}`}>
                                    <li key={game.IdJogo}>{game.NomeJogo}</li>
                                    </Link>
                                ))}
                            </ul>
                        </div>
                    )}

                    {type === 'L' && companyData.length > 0 && (
                        <div>
                            <h3>Store Games</h3>
                            <ul>
                                {companyData.map(game => (
                                    <Link to={`/game/${game.IdJogo}`} key={`${game.IdJogo}`}>
                                    <li key={game.IdJogo}>
                                        {game.NomeJogo} - ${game.preco}
                                    </li>
                                    </Link>
                                ))}
                            </ul>
                        </div>
                    )}

                    {companyData.length === 0 && <div>No games found</div>}
                </div>
            </main>
            <Footer />
        </div>
    );
}

export default CompanyDetails;