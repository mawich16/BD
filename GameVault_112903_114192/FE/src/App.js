import React, { useEffect, useState } from "react";
import "./App.css";
import Carousel from './components/Carousel';
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import axios from 'axios';
import AccountModal from './components/AccountModal';

function App() {
  const [slides, setSlides] = useState([]);
  const [showAccountModal, setShowAccountModal] = useState(false);

  useEffect(() => {
    const fetchTopRatedGames = async () => {
      try {
        const response = await axios.get('http://localhost:5000/api/topRatedGames?numberOfGames=6');
        setSlides(response.data.map(game => ({
          image: game.Imagem,
          text: game.Nome,
          gameId: game.ID,
          rating: `${game.Rating}`,
          developer: game.NomeDesenvolvedora,
          year: new Date(game.Data_lancamento).toLocaleDateString(undefined, { day: '2-digit', month: '2-digit', year: 'numeric' }),
          reviews: game.Num_Reviews
        })));
      } catch (error) {
        console.error('Error fetching top rated games:', error);
      }
    };

    fetchTopRatedGames();
  }, []);

  const handleAccountModalClose = () => {
    setShowAccountModal(false);
  };

  return (
    <div className="app">
      <Navbar onLoginClick={() => setShowAccountModal(true)} />
      <main>
        <h1><strong>Top 6 Rated Games!</strong></h1>
        <Carousel slides={slides} />
      </main>
      <Footer />
      {showAccountModal && <AccountModal onClose={handleAccountModalClose} />}
    </div>
  );
}

export default App;