import axios from 'axios';
import React, { useEffect, useState } from 'react';
import ReAuth from './ReAuth';

function EditReplyModal({ isVisible, onClose, onFailure, onSuccess, reply}) {
    const [content, setContent] = useState('');
    const [errorMessage, setErrorMessage] = useState('');
    const [isReAuthVisible, setIsReAuthVisible] = useState(false);

    useEffect(() => {
        if (isVisible && reply) {
            setContent(reply.content);
        }
        }, [isVisible, reply]);

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
        try {
            const response = await axios.post(`http://localhost:5000/api/editReply`, {
                replyID: reply.ID,
                content,
                userId
            });
            console.log('Response from backend:', response.data);
        if (response.data.message === 'Reply updated successfully!') {
            onClose();
            onSuccess();
        } else {
            setErrorMessage(response.data.message);
        }
    } catch (error) {
        console.error('Error submitting reply:', error);
        setErrorMessage('An error occurred. Please try again.');
    }
    console.log(reply.ID,content,userId)
};

    const handleReplySubmit = () => {
        setIsReAuthVisible(true);
    };

    if (!isVisible) return null;

    const isSubmitDisabled = content === '';

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={onClose}>
        <div className="relative bg-white p-6 rounded-lg shadow-lg w-80" onClick={(e) => e.stopPropagation()}>
        <button className="absolute top-2 right-2 text-2xl" onClick={onClose}>&times;</button>
        <h2 className="text-2xl font-bold mb-4">Reply</h2>
        <div className="mb-4">
            <label htmlFor="content" className="block text-sm font-medium text-gray-700">Content:</label>
            <textarea
            id="content"
            placeholder="Leave a comment..."
            value={content}
            onChange={(e) => setContent(e.target.value)}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md text-xs h-24"
            ></textarea>
        </div>
        {errorMessage && <p className="text-red-500 text-sm mb-4">{errorMessage}</p>}
        <button
            onClick={handleReplySubmit}
            className={`w-full py-2 rounded-md hover:bg-red-700 ${isSubmitDisabled ? 'bg-red-400 cursor-not-allowed' : 'bg-red-600 text-white'}`}
            disabled={isSubmitDisabled}
            title={isSubmitDisabled ? 'Please provide content' : ''}
        >
            Edit Reply
        </button>
        </div>
        {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
    </div>
    );
}

export default EditReplyModal;