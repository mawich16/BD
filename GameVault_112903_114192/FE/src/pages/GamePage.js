import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import 'react-tooltip/dist/react-tooltip.css';
import '../pages/GamePage.css';
import axios from 'axios';
import ReviewModal from '../components/ReviewModal';
import AlertModal from '../components/AlertModal';
import ReAuth from '../components/ReAuth';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEdit, faTrashAlt, faThumbsUp, faThumbsDown } from '@fortawesome/free-solid-svg-icons';
import DeleteConfirmationModal from '../components/DeleteConfirmationModal';

function formatRating(rating) {
  return Number.isInteger(rating) ? rating : rating.toFixed(2);
}

function formatTime(time) {
  const date = new Date(time);

  if (isNaN(date)) {
    throw new Error("Invalid date");
  }

  return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false, timeZone: 'UTC' });
}

function generateInitialReviews(reviews) {
  return reviews.map(review => ({
    id : `${review.ID}`,
    user: `${review.Username || review.Nome}`,
    userID : `${review.Utilizador_ID}`,
    rating: formatRating(review.Rating),
    review: review.Comentario,
    date: new Date(review.Data_review).toLocaleDateString(),
    time: formatTime(review.Hora),
    upvotes: review.Upvotes,
    downvotes: review.Downvotes,
    userVote: review.UserVote || 0
  }));
}

function GameDetails({ game, reviewCount }) {
  return (
    <div className="bg-white p-6 rounded-lg shadow-md mb-6">
      <img src={game.Imagem} alt={`Game Image of ${game.Nome}`} className="w-full h-64 object-cover rounded-md mb-4" />
      <div className="text-lg font-bold mb-2">{game.Nome}</div>
      <p className="text-gray-700"><strong>Description:</strong> {game.Descricao}</p>
      <p className="text-gray-700"><strong>Rating:</strong> {formatRating(game.Rating)}</p>
      <p className="text-gray-700"><strong>Reviews:</strong> {reviewCount}</p>
      <p className="text-gray-700"><strong>Platform:</strong> {game.NomePlataforma}</p>
      <p className="text-gray-700"><strong>Genre:</strong> {game.Genero}</p>
      <p className="text-gray-700"><strong>Editor:</strong> {game.NomeEditora}</p>
      <p className="text-gray-700"><strong>Developer:</strong> {game.NomeDesenvolvedora}</p>
      <p className="text-gray-700"><strong>Year:</strong> {new Date(game.Data_lancamento).getFullYear()}</p>
    </div>
  );
}

function PreviousReviews({ reviews, onReAuthComplete }) {
  const [currentPage, setCurrentPage] = useState(1);
  const [isReviewModalVisible, setIsReviewModalVisible] = useState(false);
  const [selectedReview, setSelectedReview] = useState(null);
  const [alertMessage, setAlertMessage] = useState('');
  const [isDeleteModalVisible, setIsDeleteModalVisible] = useState(false);
  const [reviewToDelete, setReviewToDelete] = useState(null);
  const [isReAuthVisible, setIsReAuthVisible] = useState(false); // Add state for reauthentication
  const [currentAction, setCurrentAction] = useState(null); // Add state for the current action
  const reviewsPerPage = 5;

  const indexOfLastReview = currentPage * reviewsPerPage;
  const indexOfFirstReview = indexOfLastReview - reviewsPerPage;
  const currentReviews = reviews.slice(indexOfFirstReview, indexOfLastReview);
  const totalPages = Math.ceil(reviews.length / reviewsPerPage);

  const renderPageNumbers = () => {
    const pageNumbers = [];
    for (let i = 1; i <= totalPages; i++) {
      pageNumbers.push(
        <button
          key={i}
          onClick={() => setCurrentPage(i)}
          className={`py-2 px-4 ${currentPage === i ? 'bg-red-500 text-white' : 'bg-gray-300 text-gray-700'} hover:bg-gray-400 rounded-md`}
        >
          {i}
        </button>
      );
    }
    return pageNumbers;
  };

  const getUserId = () => {
    const authData = JSON.parse(sessionStorage.getItem("auth")) || JSON.parse(localStorage.getItem("auth"));
    return authData ? authData.id : null;
  };

  const handleEditClick = (review) => {
    handleButtonClick();
    setSelectedReview(review);
    setCurrentAction(() => () => {
      setIsReviewModalVisible(true);
    });
    if (checkUserLoggedIn()) {
      setIsReviewModalVisible(true);
    } else {
      setAlertMessage('You need to log in to edit reviews.');
      setIsReAuthVisible(true);
    }
  };

  const handleEditSuccess = () => {
    setIsReviewModalVisible(false);
    setAlertMessage('Review updated successfully!');
    setTimeout(() => {
      window.location.reload();
    }, 1000);
  };

  const handleDeleteClick = (review) => {
    handleButtonClick();
    setReviewToDelete(review);
    setCurrentAction(() => confirmDelete);
    if (checkUserLoggedIn()) {
      setIsDeleteModalVisible(true);
    } else {
      setAlertMessage('You need to log in to delete reviews.');
      setIsReAuthVisible(true);
    }
  };

  const confirmDelete = async () => {
    if (!reviewToDelete) return;

    const userId = getUserId();
    try {
      const response = await axios.post('http://localhost:5000/api/deleteReview', { reviewID: reviewToDelete.id, userID: userId });
      if (response.data.message === 'Review deleted successfully!') {
        setIsDeleteModalVisible(false);
        setReviewToDelete(null);
        window.location.reload();
      } else {
        alert(response.data.message);
      }
    } catch (error) {
      console.error('Error deleting review:', error);
      alert('An error occurred. Please try again.');
    }
  };

  const cancelDelete = () => {
    setIsDeleteModalVisible(false);
    setReviewToDelete(null);
  };

  const handleUpvote = async (reviewId) => {
    handleButtonClick();
    setCurrentAction(() => () => upvote(reviewId));
    if (checkUserLoggedIn()) {
    } else {
        setAlertMessage('You need to log in to upvote reviews.');
        setIsReAuthVisible(true);
    }
};

const upvote = async (reviewId) => {
    try {
        const response = await axios.post('http://localhost:5000/api/upvote', { reviewID: reviewId, userID: getUserId() });
        const message = response.data.message;
        console.log(response.data.message)
        setAlertMessage(message);
        if (message.includes('successfully') || message.includes('changed') || message.includes('removed')) {
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        }
    } catch (error) {
        console.error('Error upvoting review:', error);
        alert('An error occurred. Please try again.');
    }
};

const handleDownvote = async (reviewId) => {
  handleButtonClick();
  setCurrentAction(() => () => downvote(reviewId));
  if (checkUserLoggedIn()) {
  } else {
      setAlertMessage('You need to log in to downvote reviews.');
      setIsReAuthVisible(true);
  }
};

const downvote = async (reviewId) => {
  try {
      const response = await axios.post('http://localhost:5000/api/downvote', { reviewID: reviewId, userID: getUserId() });
      const message = response.data.message;
      setAlertMessage(message);
      if (message.includes('successfully') || message.includes('changed') || message.includes('removed')) {
          setTimeout(() => {
              window.location.reload();
          }, 1000);
      }
  } catch (error) {
      console.error('Error downvoting review:', error);
      alert('An error occurred. Please try again.');
  }
};

  const checkUserLoggedIn = () => {
    const authData = JSON.parse(sessionStorage.getItem("auth")) || JSON.parse(localStorage.getItem("auth"));
    return authData ? authData.id : null;
  };

  const handleButtonClick = () => {
    setIsReAuthVisible(true);
  };

  const handleReAuthComplete = () => {
    const userId = checkUserLoggedIn();
    if (userId && currentAction) {
      currentAction();
    } else {
      setAlertMessage('Authentication failed. Please log in and try again.');
      setTimeout(() => {
        window.location.reload();
      }
      , 1000);
    }
    setIsReAuthVisible(false);
  };

  const handleFailure = () => {
    setAlertMessage('Authentication failed. Please log in and try again.');
    setTimeout(() => {
      window.location.reload();
    }
    , 1000);
  };

  return (
    <div className="bg-white p-6 rounded-lg shadow-md mb-6">
      <h3 className="text-lg font-bold mb-4">Reviews</h3>
      <hr className="my-4" />
      <ul>
        {currentReviews.map((review, index) => (
          <li key={index} className="mb-4 flex justify-between items-start w-72">
            <div>
              <p className="font-semibold">
                {review.user} - Rating: {review.rating}
                {parseInt(review.userID, 10) === getUserId() && (
                  <span className="ml-2">
                    <button
                      className="text-blue-500 hover:text-blue-700 mr-2"
                      onClick={() => handleEditClick(review)}
                    >
                      <FontAwesomeIcon icon={faEdit} />
                    </button>
                    <button
                      className="text-red-500 hover:text-red-700"
                      onClick={() => handleDeleteClick(review)}
                    >
                      <FontAwesomeIcon icon={faTrashAlt} />
                    </button>
                  </span>
                )}
              </p>
              <p className="text-gray-400 text-sm">{review.date} at {review.time}</p>
              <p className="text-gray-600">{review.review}</p>
              <div className="flex items-center">
                <button className={`mr-2 ${review.userVote === 1 ? 'text-green-500' : 'text-gray-500'} hover:text-green-700`} onClick={() => handleUpvote(review.id)}>
                  <FontAwesomeIcon icon={faThumbsUp} /> {review.upvotes}
                </button>
                <button className={`${review.userVote === -1 ? 'text-red-500' : 'text-gray-500'} hover:text-red-700`} onClick={() => handleDownvote(review.id)}>
                  <FontAwesomeIcon icon={faThumbsDown} /> {review.downvotes}
                </button>
              </div>
            </div>
          </li>
        ))}
      </ul>
      {reviews.length > reviewsPerPage && (
        <div className="flex justify-center mt-4 space-x-2">
          {renderPageNumbers()}
        </div>
      )}
      <ReviewModal
        isVisible={isReviewModalVisible}
        onClose={() => setIsReviewModalVisible(false)}
        gameId={null}
        onSuccess={handleEditSuccess}
        onFailure={handleFailure}
        review={selectedReview}
      />
      <DeleteConfirmationModal
        isVisible={isDeleteModalVisible}
        review={reviewToDelete}
        onConfirm={confirmDelete}
        onCancel={cancelDelete}
      />
      {alertMessage && <AlertModal message={alertMessage} onClose={() => setAlertMessage('')} />}
      {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
    </div>
  );
}

function Dlcs({ dlcs }) {
  return (
    <div className="bg-white p-6 rounded-lg shadow-md mb-6">
      <h3 className="text-lg font-bold mb-4">Downloadable Content (DLCs)</h3>
      <hr className="my-4" />
      {dlcs.length > 0 ? (
        <ul>
          {dlcs.map((dlc, index) => (
            <li key={index} className="mb-4">
              <p className="font-semibold">{dlc.NomeDLC}</p>
              <p className="text-gray-600">Type: {dlc.TipoDLC}</p>
              <p className="text-gray-600">Release Date: {new Date(dlc.Data_lancamento).toLocaleDateString()}</p>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-gray-600">No DLCs available for this game.</p>
      )}
    </div>
  );
}

function GamePage() {
  const { id } = useParams();
  const [game, setGame] = useState(null);
  const [reviews, setReviews] = useState([]);
  const [reviewCount, setReviewCount] = useState(0);
  const [dlcs, setDlcs] = useState([]);
  const [isReviewModalVisible, setIsReviewModalVisible] = useState(false);
  const [alertMessage, setAlertMessage] = useState('');
  const [isReAuthVisible, setIsReAuthVisible] = useState(false);

  useEffect(() => {
    const fetchGameDetails = async () => {
      try {
        const response = await axios.get(`http://localhost:5000/api/game/${id}`);
        if (response.data) {
          console.log('Fetched game data:', response.data); // Debugging step
          setGame(response.data);
        } else {
          console.error('Game data is undefined:', response.data);
        }
      } catch (error) {
        console.error('Error fetching game details:', error);
      }
    };

    const fetchGameReviews = async () => {
      try {
        const userId = checkUserLoggedIn(); // Make sure to get the logged-in user's ID
        const response = await axios.get(`http://localhost:5000/api/reviews/${id}/${userId || ''}`);
        if (response.data) {
          console.log('Fetched reviews data:', response.data); // Debugging step
          setReviews(generateInitialReviews(response.data));
          setReviewCount(response.data.length);
        } else {
          console.error('Reviews data is undefined:', response.data);
        }
      } catch (error) {
        console.error('Error fetching game reviews:', error);
      }
    };

    const fetchGameDlcs = async () => {
      try {
        const response = await axios.get(`http://localhost:5000/api/dlcs/${id}`);
        if (response.data) {
          console.log('Fetched DLCs data:', response.data); // Debugging step
          setDlcs(response.data);
        } else {
          console.error('DLCs data is undefined:', response.data);
        }
      } catch (error) {
        console.error('Error fetching game DLCs:', error);
      }
    };

    fetchGameDetails();
    fetchGameReviews();
    fetchGameDlcs();
  }, [id]);

  const checkUserLoggedIn = () => {
    const authData = JSON.parse(sessionStorage.getItem("auth")) || JSON.parse(localStorage.getItem("auth"));
    return authData ? authData.id : null;
  };

  const handleRateButtonClick = () => {
    if (checkUserLoggedIn()) {
      setIsReviewModalVisible(true);
    } else {
      setAlertMessage('You need to log in to review games.');
    }
    setIsReAuthVisible(true);
  };

  const handleFailure = () => {
    setAlertMessage('Authentication failed. Please log in and try again.');
    setTimeout(() => {
      window.location.reload();
    }
    , 1000);
  };

  const handleReAuthComplete = () => {
    const userId = checkUserLoggedIn();
    if (userId) {
      setIsReviewModalVisible(true);
    } else {
      setIsReviewModalVisible(false);
      setAlertMessage('You need to log in to review games.');
    }
    setIsReAuthVisible(false);
  };

  const handleSuccess = () => {
    setAlertMessage('Review submitted successfully!');
    setTimeout(() => {
      window.location.reload();
    }, 1000);
  };

  if (!game) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <Navbar />
      <main className="container mx-auto p-6 w-full flex justify-center w-full max-w-screen-lg">
        <h1 className="text-3xl font-bold mb-6">{game.Nome}</h1>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2">
            <GameDetails game={game} reviewCount={reviewCount} />
            <Dlcs dlcs={dlcs} />
            <button
              className="bg-red-600 text-white py-2 px-4 rounded-md hover:bg-red-700 w-full mt-4"
              onClick={handleRateButtonClick}
            >
              Rate {game.Nome}!
            </button>
          </div>
          <div>
            <PreviousReviews reviews={reviews} />
          </div>
        </div>
      </main>
      <Footer />
      <ReviewModal isVisible={isReviewModalVisible} onClose={() => setIsReviewModalVisible(false)} gameId={id} onFailure={handleFailure} onSuccess={handleSuccess} />
      {alertMessage && <AlertModal message={alertMessage} onClose={() => setAlertMessage('')} />}
      {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
    </div>
  );
}

export default GamePage;