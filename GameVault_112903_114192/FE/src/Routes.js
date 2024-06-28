import React from 'react';
import { Route, BrowserRouter as Router, Routes, useParams } from 'react-router-dom';
import App from './App';
import gameData from './components/ListData.json';
import CommunityPage from './pages/Community';
import CompaniesPage from './pages/Companies';
import CompanyDetails from './pages/CompanyDetails';
import GamePage from './pages/GamePage';
import HelpPage from './pages/Help';
import SearchPage from './pages/SearchPage';
import ProfilePage from './pages/ProfilePage';

function AppRoutes() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<App />} />
        <Route path="/search" element={<SearchPage />} />
        <Route path="/companies" element={<CompaniesPage />} />
        <Route path="/companyDetails/:id/:type" element={<CompanyDetails />} />
        <Route path="/community" element={<CommunityPage />} />
        <Route path="/help" element={<HelpPage />} />
        <Route path="/game/:id" element={<DynamicGamePage gameData={gameData} />} />
        < Route path="/profile" element={<ProfilePage />} /> 
      </Routes>
    </Router>
  );
}

function DynamicGamePage({ gameData }) {
  const { id } = useParams();

  if (!gameData || gameData.length === 0) {return <div>Loading...</div>;}

  const game = gameData.find((game) => game.id === parseInt(id));

  if (!game) {return <div>Game not found!</div>;}

  return <GamePage game={game} />;
}

export default AppRoutes;