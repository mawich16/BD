import axios from 'axios';
import React, { useEffect, useState } from 'react';
import ReAuth from './ReAuth';

function PostModal({ isVisible, onClose, onFailure, onSuccess, post}) {
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');
    const [errorMessage, setErrorMessage] = useState('');
    const [isReAuthVisible, setIsReAuthVisible] = useState(false);

    useEffect(() => {
        if (isVisible && post) {
            setTitle(post.title);
            setContent(post.content);
        } else {
            setTitle('');
            setContent('');
        }
        }, [isVisible, post]);

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
        const url = post ? 'http://localhost:5000/api/editPost' : 'http://localhost:5000/api/addPost';
        const data = post
        ? { postID: post.IdPost, userID: userId, content, title }
        : { content, userId, title };

        try {
            const response = await axios.post(url, data);

        if (response.data.message === 'Post added successfully!' || response.data.message === 'Post updated successfully!') {
            onClose();
            onSuccess();
        } else {
            setErrorMessage(response.data.message);
        }
    } catch (error) {
        console.error('Error submitting post:', error);
        setErrorMessage('An error occurred. Please try again.');
    }};

    const handlePostSubmit = () => {
        setIsReAuthVisible(true);
    };

    if (!isVisible) return null;

    const isSubmitDisabled = title === '';

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={onClose}>
        <div className="relative bg-white p-6 rounded-lg shadow-lg w-80" onClick={(e) => e.stopPropagation()}>
        <button className="absolute top-2 right-2 text-2xl" onClick={onClose}>&times;</button>
        <h2 className="text-2xl font-bold mb-4">Post</h2>
        <div className="mb-4">
            <label htmlFor="title" className="block text-sm font-medium text-gray-700">Title:</label>
            <input
            type="title"
            placeholder="title"
            id="title"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md text-xs h-8"
            />
        </div>
        <div className="mb-4">
            <label htmlFor="contente" className="block text-sm font-medium text-gray-700">Content:</label>
            <textarea
            id="content"
            placeholder="..."
            value={content}
            onChange={(e) => setContent(e.target.value)}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md text-xs h-24"
            ></textarea>
        </div>
        {errorMessage && <p className="text-red-500 text-sm mb-4">{errorMessage}</p>}
        <button
            onClick={handlePostSubmit}
            className={`w-full py-2 rounded-md hover:bg-red-700 ${isSubmitDisabled ? 'bg-red-400 cursor-not-allowed' : 'bg-red-600 text-white'}`}
            disabled={isSubmitDisabled}
            title={isSubmitDisabled ? 'Please provide a title' : ''}
        >
            {post ? 'Edit Post' : 'Submit Post'}
        </button>
        </div>
        {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
    </div>
    );
}

export default PostModal;