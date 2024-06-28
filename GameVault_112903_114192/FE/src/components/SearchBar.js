import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import gameData from './ListData.json';

const SearchBar = () => {
  const [searchInput, setSearchInput] = useState('');
  const [filteredGames, setFilteredGames] = useState([]);
  const searchContainerRef = useRef(null);
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { value } = e.target;
    setSearchInput(value);

    if (value.trim() !== '') {
      const filtered = gameData.filter((game) =>
        game.name.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredGames(filtered);
    } else {
      setFilteredGames([]);
    }
  };

  const handleGameSelect = (gameId) => {
    setSearchInput('');
    setFilteredGames([]);
    navigate(`/game/${gameId}`);
  };

  const handleClickOutside = (event) => {
    if (searchContainerRef.current && !searchContainerRef.current.contains(event.target)) {
      setFilteredGames([]);
      setSearchInput('');
    }
  };

  useEffect(() => {
    document.addEventListener('mousedown', handleClickOutside);

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  return (
    <div className="relative w-full max-w-sm mx-auto" ref={searchContainerRef}>
      <input
        type="search"
        placeholder="Search here"
        onChange={handleChange}
        value={searchInput}
        className="w-full px-2 py-1 text-sm rounded-lg hover:bg-gray-100 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-red-500"
      />
      {searchInput.trim() !== '' && (
        <div className="absolute w-full bg-white border border-gray-300 rounded-lg mt-1 z-10 max-h-60 overflow-y-auto">
          {filteredGames.length > 0 ? (
            <ul>
              {filteredGames.map((game) => (
                <li
                  key={game.id}
                  onClick={() => handleGameSelect(game.id)}
                  className="px-2 py-1 text-sm hover:bg-gray-100 cursor-pointer"
                >
                  {game.name}
                </li>
              ))}
            </ul>
          ) : (
            <p className="px-2 py-1 text-sm text-gray-500">No matching games found.</p>
          )}
        </div>
      )}
    </div>
  );
};

export default SearchBar;