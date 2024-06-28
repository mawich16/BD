import React from 'react';
import './Help.css';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';

function HelpPage() {
  return (
    <div className="companies-page">
      <Navbar />
      <h1>Welcome to the Companies Page</h1>
      <p>This is the page where we can help you discover the website!</p>
      <Footer />
    </div>
  );
}

export default HelpPage;
