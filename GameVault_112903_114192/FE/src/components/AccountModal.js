import React, { useState } from "react";
import axios from 'axios';
import "./AccountModal.css";
import SuccessModal from './SuccessModal';
import AlertModal from './AlertModal';

const AccountModal = ({ onClose }) => {
    const [isRegisterMode, setIsRegisterMode] = useState(false);
    const [formData, setFormData] = useState({ name: "", email: "", password: "", confirmPassword: "" });
    const [error, setError] = useState("");
    const [passwordMatch, setPasswordMatch] = useState(null);
    const [showSuccessModal, setShowSuccessModal] = useState(false);
    const [showUsernameTooltip, setShowUsernameTooltip] = useState(false);
    const [showEmailTooltip, setShowEmailTooltip] = useState(false);
    const [staySignedIn, setStaySignedIn] = useState(false);
    const [alertMessage, setAlertMessage] = useState("");

    const toggleMode = () => {
        setIsRegisterMode(!isRegisterMode);
        setFormData({ name: "", email: "", password: "", confirmPassword: "" });
        setError("");
        setPasswordMatch(null);
        setShowUsernameTooltip(false);
        setShowEmailTooltip(false); // Reset email tooltip
    };

    const handleChange = (event) => {
        const { name, value } = event.target;
        setFormData((prevFormData) => {
            const newFormData = { ...prevFormData, [name]: value };
            if (name === "name") {
                const isValidUsername = /^[A-Za-z][A-Za-z0-9._]{2,119}$/.test(value);
                setShowUsernameTooltip(!isValidUsername && value !== "");
            }
            if (name === "email") {
                const isValidEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
                setShowEmailTooltip(!isValidEmail && value !== "");
            }
            if (name === "password" || name === "confirmPassword") {
                if (newFormData.password && newFormData.confirmPassword) {
                    setPasswordMatch(newFormData.password === newFormData.confirmPassword);
                } else {
                    setPasswordMatch(null);
                }
            }
            if (newFormData.email && newFormData.password && (!isRegisterMode || (isRegisterMode && newFormData.name && newFormData.confirmPassword))) {
                setError("");
            }
            return newFormData;
        });
    };

    const handleSubmit = async (event) => {
        event.preventDefault();
        if (!formData.email || !formData.password || (isRegisterMode && (!formData.name || !formData.confirmPassword))) {
            setError("Please fill in all the information.");
            return;
        }
    
        if (isRegisterMode && formData.password !== formData.confirmPassword) {
            setError("Passwords do not match");
            return;
        }
    
        try {
            if (isRegisterMode) {
                const response = await axios.post('http://localhost:5000/api/register', {
                    username: formData.name,
                    password: formData.password,
                    email: formData.email,
                });
                if (response.data.success) {
                    setShowSuccessModal(true);
                } else {
                    setError(response.data.message || "Registration failed.");
                }
            } else {
                const response = await axios.post('http://localhost:5000/api/authenticate', {
                    email: formData.email,
                    password: formData.password,
                    staySignedIn: staySignedIn,
                });
                if (response.data.success) {
                    setAlertMessage("Login successful!");
                    const authData = { token: response.data.token, username: response.data.username, id: response.data.id};
                    if (staySignedIn) {
                        localStorage.setItem("auth", JSON.stringify(authData));
                    } else {
                        sessionStorage.setItem("auth", JSON.stringify(authData));
                    }
                    setTimeout(() => {
                        onClose();
                        window.location.reload();
                    }, 1000);
                } else {
                    setError(response.data.message || "Invalid credentials.");
                }
            }
        } catch (err) {
            console.error(err);
            setError("An error occurred. Please try again.");
        }
    };    

    const handleSuccessModalClose = () => {
        setShowSuccessModal(false);
        setIsRegisterMode(false);
        setFormData({ name: "", email: "", password: "", confirmPassword: "" });
    };

    const handleOverlayClick = (event) => {
        if (event.target === event.currentTarget) {
            onClose();
        }
    };

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={handleOverlayClick}>
            {alertMessage && <AlertModal message={alertMessage} onClose={() => setAlertMessage("")} />}
            <div className="relative bg-white p-6 rounded-lg shadow-lg w-80" onClick={(e) => e.stopPropagation()}>
                <button className="absolute top-2 right-2 text-2xl" onClick={onClose}>&times;</button>
                <h2 className="text-2xl font-bold mb-4">{isRegisterMode ? "Register" : "Login"}</h2>
                <form onSubmit={handleSubmit} className="space-y-4">
                    {isRegisterMode && (
                        <div className="relative">
                            <label htmlFor="name" className="block text-sm font-medium text-gray-700">Name:</label>
                            <input
                                type="text"
                                id="name"
                                name="name"
                                placeholder="Enter your name"
                                value={formData.name}
                                onChange={handleChange}
                                className="hover:bg-gray-100 mt-1 block w-full border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm p-2"
                            />
                            {showUsernameTooltip && (
                                <div className="absolute top-full mt-1 w-full bg-yellow-100 border border-yellow-400 text-yellow-700 p-2 rounded z-10">
                                    Username must be 3-120 characters long, start with a letter, and can only contain letters, numbers, dots, and underscores.
                                </div>
                            )}
                        </div>
                    )}
                    <div className="relative">
                        <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email:</label>
                        <input
                            type="text"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            value={formData.email}
                            onChange={handleChange}
                            className="hover:bg-gray-100 mt-1 block w-full border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm p-2"
                        />
                        {showEmailTooltip && (
                            <div className="absolute top-full mt-1 w-full bg-yellow-100 border border-yellow-400 text-yellow-700 p-2 rounded">
                                Please enter a valid email address.
                            </div>
                        )}
                    </div>
                    <div>
                        <label htmlFor="password" className="block text-sm font-medium text-gray-700">Password:</label>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            value={formData.password}
                            onChange={handleChange}
                            className="hover:bg-gray-100 mt-1 block w-full border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm p-2"
                        />
                    </div>
                    {isRegisterMode && (
                        <div>
                            <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700">Confirm Password:</label>
                            <input
                                type="password"
                                id="confirmPassword"
                                name="confirmPassword"
                                placeholder="Confirm your password"
                                value={formData.confirmPassword}
                                onChange={handleChange}
                                className="hover:bg-gray-100 mt-1 block w-full border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm p-2"
                            />
                            {passwordMatch !== null && (
                                <p className={`text-sm ${passwordMatch ? 'text-green-500' : 'text-red-500'}`}>
                                    {passwordMatch ? 'Passwords match' : 'Passwords do not match'}
                                </p>
                            )}
                        </div>
                    )}
                    {!isRegisterMode && (
                        <div className="stay-signed-in-container flex items-center">
                            <input
                                type="checkbox"
                                id="staySignedIn"
                                name="staySignedIn"
                                checked={staySignedIn}
                                onChange={() => setStaySignedIn(!staySignedIn)}
                                className="mr-2"
                            />
                            <label htmlFor="staySignedIn" className="text-sm text-gray-700">Stay signed in</label>
                        </div>
                    )}
                    {error && <p className="text-red-500 text-sm">{error}</p>}
                    <button
                        type="submit"
                        className={`w-full py-2 rounded-md hover:bg-red-700 ${isRegisterMode && !passwordMatch ? 'bg-red-400 cursor-not-allowed' : 'bg-red-600 text-white'}`}
                        disabled={isRegisterMode && !passwordMatch}
                        title={isRegisterMode && !passwordMatch ? 'Please fill out all fields and ensure passwords match' : ''}
                    >
                        {isRegisterMode ? "Register" : "Sign in"}
                    </button>
                </form>
                <div className="mt-6 text-center">
                    <hr className="border-gray-300" />
                    <p className="mt-4">{isRegisterMode ? "Already have an account?" : "Don't have an account?"}</p>
                    <button type="button" className="mt-2 w-full bg-red-600 text-white py-2 rounded-md hover:bg-red-700" onClick={toggleMode}>{isRegisterMode ? "Login" : "Sign up"}</button>
                </div>
            </div>
            {showSuccessModal && (
                <SuccessModal
                    onClose={handleSuccessModalClose}
                    message="Registration successful! Please log in."
                />
            )}
        </div>
    );
};

export default AccountModal;