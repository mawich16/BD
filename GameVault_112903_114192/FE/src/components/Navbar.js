import React, { useState, useEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faUser } from '@fortawesome/free-solid-svg-icons';
import AccountModal from './AccountModal';
import AlertModal from './AlertModal';
import ReAuth from './ReAuth';
import SearchBar from './SearchBar';

function Navbar() {
  const [isAccountModalOpen, setIsAccountModalOpen] = useState(false);
  const [showAccountOptions, setShowAccountOptions] = useState(false);
  const [alertMessage, setAlertMessage] = useState("");
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [username, setUsername] = useState("");
  const dropdownRef = useRef(null);

  useEffect(() => {
    const authData = localStorage.getItem('auth') || sessionStorage.getItem('auth');
    if (authData) {
      const { username } = JSON.parse(authData);
      setUsername(username);
      setIsLoggedIn(true);
    }
  }, [isLoggedIn]);

  const toggleAccountModal = () => {
    setIsAccountModalOpen(!isAccountModalOpen);
  };

  const toggleAccountOptions = () => {
    setShowAccountOptions(!showAccountOptions);
  };

  const handleLogout = () => {
    sessionStorage.removeItem('auth');
    localStorage.removeItem('auth');
    setIsLoggedIn(false);
    setShowAccountOptions(false);
    setAlertMessage("Logged out");
    setTimeout(() => {
      setAlertMessage("");
      window.location.reload();
    }, 2000);
  };

  const handleGamesClick = () => {
    sessionStorage.removeItem('filters');
    sessionStorage.removeItem('sortOption');
    if (window.location.pathname === "/search") {
      window.location.reload();
    }
  };

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setShowAccountOptions(false);
      }
    };

    if (showAccountOptions) {
      document.addEventListener('mousedown', handleClickOutside);
    } else {
      document.removeEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [showAccountOptions]);

  return (
    <header className="bg-white p-4 flex justify-between items-center shadow-md relative z-10">
      {alertMessage && <AlertModal message={alertMessage} onClose={() => setAlertMessage("")} />}
      <ul className="flex items-center space-x-4">
        <li className="logo">
          <Link to="/">
            <img src="/gygologo.png" alt="GYGO Logo" className="h-auto" />
          </Link>
        </li>
        <li>
          <Link to="/search" className="text-gray-800 hover:text-gray-600" onClick={handleGamesClick}>Games</Link>
        </li>
        <li>
          <Link to="/companies" className="text-gray-800 hover:text-gray-600">Companies</Link>
        </li>
        <li>
          <Link to="/community" className="text-gray-800 hover:text-gray-600">Community</Link>
        </li>
        <li>
          <Link to="/help" className="text-gray-800 hover:text-gray-600">Help</Link>
        </li>
        <li className="relative" ref={dropdownRef}>
          <button onClick={isLoggedIn ? toggleAccountOptions : toggleAccountModal} className="text-gray-800 hover:text-gray-600">
            <FontAwesomeIcon icon={faUser} />
          </button>
          {showAccountOptions && (
            <ul className="absolute right-100 mt-2 w-48 bg-gray-300 shadow-lg rounded-lg py-2 z-20">
              <li className="px-4 py-2 text-gray-800">
                <span>Logged in as:</span>
                <br />
                <span className="font-bold">{username}</span>
              </li>
              <li>
                <Link to="/profile" className="block px-4 py-2 text-gray-800 hover:bg-white">Profile</Link>
              </li>
              <li>
                <button onClick={handleLogout} className="block w-full text-left px-4 py-2 text-red-600 hover:bg-white">Logout</button>
              </li>
            </ul>
          )}
        </li>
      </ul>
      <div className="flex items-center mr-10">
        <SearchBar inNavbar={true} />
      </div>
      {isAccountModalOpen && <AccountModal onClose={toggleAccountModal} />}
      <ReAuth onReAuthComplete={() => setIsLoggedIn(true)} />
    </header>
  );
}

export default Navbar;