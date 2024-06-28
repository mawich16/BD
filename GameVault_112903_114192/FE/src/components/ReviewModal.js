import axios from 'axios';
import React, { useEffect, useState } from 'react';
import ReAuth from './ReAuth';

function ReviewModal({ isVisible, onClose, gameId, onFailure, onSuccess, review }) {
  const [rating, setRating] = useState('');
  const [comment, setComment] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [isReAuthVisible, setIsReAuthVisible] = useState(false);

  useEffect(() => {
    if (isVisible && review) {
      setRating(review.rating);
      setComment(review.review);
    } else {
      setRating('');
      setComment('');
    }
  }, [isVisible, review]);

  const getUserId = () => {
    const authData = JSON.parse(sessionStorage.getItem("auth")) || JSON.parse(localStorage.getItem("auth"));
    return authData ? authData.id : null;
  };

  const handleReAuthComplete = () => {
    const userId = getUserId();
    if (userId) {
      handleSubmit(userId);
    } else {
      onFailure();
    }
    setIsReAuthVisible(false);
  };

  const handleSubmit = async (userId) => {
    const url = review ? 'http://localhost:5000/api/editReview' : 'http://localhost:5000/api/review';
    const data = review
      ? { reviewID: review.id, userID: userId, comment, rating }
      : { comment, ID: userId, gameID: gameId, rating };

    try {
      const response = await axios.post(url, data);

      if (response.data.message === 'Review added successfully!' || response.data.message === 'Review updated successfully!') {
        onClose();
        onSuccess();
      } else {
        setErrorMessage(response.data.message);
      }
    } catch (error) {
      console.error('Error submitting review:', error);
      setErrorMessage('An error occurred. Please try again.');
    }
  };

  const handleReviewSubmit = () => {
    setIsReAuthVisible(true);
  };

  if (!isVisible) return null;

  const isSubmitDisabled = rating === '';

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={onClose}>
      <div className="relative bg-white p-6 rounded-lg shadow-lg w-80" onClick={(e) => e.stopPropagation()}>
        <button className="absolute top-2 right-2 text-2xl" onClick={onClose}>&times;</button>
        <h2 className="text-2xl font-bold mb-4">{review ? 'Edit Review' : 'Rate Game'}</h2>
        <div className="mb-4">
          <label htmlFor="rating" className="block text-sm font-medium text-gray-700">Rating (0-5):</label>
          <input
            type="number"
            placeholder="0,0-5,0"
            id="rating"
            value={rating}
            onChange={(e) => setRating(Math.min(5, Math.max(0, parseFloat(e.target.value)).toFixed(1)))}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md text-xs h-8"
            min="0"
            max="5"
            step="0.1"
          />
        </div>
        <div className="mb-4">
          <label htmlFor="comment" className="block text-sm font-medium text-gray-700">Comment:</label>
          <textarea
            id="comment"
            placeholder="Leave a comment..."
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md text-xs h-24"
          ></textarea>
        </div>
        {errorMessage && <p className="text-red-500 text-sm mb-4">{errorMessage}</p>}
        <button
          onClick={handleReviewSubmit}
          className={`w-full py-2 rounded-md hover:bg-red-700 ${isSubmitDisabled ? 'bg-red-400 cursor-not-allowed' : 'bg-red-600 text-white'}`}
          disabled={isSubmitDisabled}
          title={isSubmitDisabled ? 'Please provide a rating' : ''}
        >
          {review ? 'Edit Review' : 'Submit Review'}
        </button>
      </div>
      {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
    </div>
  );
}

export default ReviewModal;