import React, { useState, useEffect, useRef } from 'react';
import './Carousel.css';

function Carousel({ slides }) {
  const [currentSlide, setCurrentSlide] = useState(0);
  const intervalRef = useRef(null);

  useEffect(() => {
    startSlideShow();
    return () => clearInterval(intervalRef.current);
  }, [slides.length]);

  const startSlideShow = () => {
    clearInterval(intervalRef.current);
    intervalRef.current = setInterval(() => {
      setCurrentSlide(prevSlide => (prevSlide === slides.length - 1 ? 0 : prevSlide + 1));
    }, 8000);
  };

  const nextSlide = () => {
    setCurrentSlide(prevSlide => (prevSlide === slides.length - 1 ? 0 : prevSlide + 1));
  };

  const prevSlide = () => {
    setCurrentSlide(prevSlide => (prevSlide === 0 ? slides.length - 1 : prevSlide - 1));
  };

  const handleMouseEnter = () => {
    clearInterval(intervalRef.current);
  };

  const handleMouseLeave = () => {
    startSlideShow();
  };

  if (slides.length === 0) {
    return <div>Loading...</div>;
  }

  return (
    <div className="carousel-container" onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave}>
      <div className="carousel">
        <button className="prev" onClick={prevSlide}>&#10094;</button>
        <div className="slides-container">
          {slides.map((slide, index) => (
            <div key={index} className={index === currentSlide ? "slide active" : "slide"}>
              <a href={`/game/${slide.gameId}`} className="slide-link">
                <div className="image" style={{ backgroundImage: `url(${slide.image})` }}></div>
              </a>
            </div>
          ))}
        </div>
        <button className="next" onClick={nextSlide}>&#10095;</button>
      </div>
      <div className="carousel-details">
        <h2>{slides[currentSlide].text}</h2>
        <p><strong>Developer:</strong> {slides[currentSlide].developer || "N/A"}</p>
        <p><strong>Rating:</strong> {slides[currentSlide].rating || "N/A"}</p>
        <p><strong>Number of Reviews:</strong> {slides[currentSlide].reviews || "N/A"}</p>
        <p><strong>Release Date:</strong> {slides[currentSlide].year || "N/A"}</p>
      </div>
      <div className="carousel-indicators">
        {slides.map((_, index) => (
          <span
            key={index}
            className={`indicator ${index === currentSlide ? 'active' : ''}`}
            onClick={() => setCurrentSlide(index)}
          ></span>
        ))}
      </div>
    </div>
  );
}

export default Carousel;