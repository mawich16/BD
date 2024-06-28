import { faEdit, faThumbsDown, faThumbsUp, faTimes, faTrashAlt } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import axios from 'axios';
import { default as React, useCallback, useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import 'react-tooltip/dist/react-tooltip.css';
import AlertModal from '../components/AlertModal';
import DeletePostConfirmationModal from '../components/DeletePostConfirmationModal';
import DeleteReplyConfirmationModal from '../components/DeleteReplyConfirmationModal';
import EditReplyModal from '../components/EditReplyModal';
import Footer from '../components/Footer';
import Navbar from '../components/Navbar';
import PostModal from '../components/PostModal';
import ReAuth from '../components/ReAuth';
import './Community.css';

function CommunityPage() {
    const [posts, setPosts] = useState([]);
    const [isPostModalVisible, setIsPostModalVisible] = useState(false);
    const [searchInput, setSearchInput] = useState('');
    const [showAllPosts, setShowAllPosts] = useState(false);
    const [sortOption, setSortOption] = useState('default');
    const [isSearching, setIsSearching] = useState(false);
    const [sortedPosts, setSortedPosts] = useState([]);
    const [alertMessage, setAlertMessage] = useState('');
    const [isReAuthVisible, setIsReAuthVisible] = useState(false);

    const location = useLocation();

    useEffect(() => {
        const savedSortOption = sessionStorage.getItem('sortOption');
        const queryParams = new URLSearchParams(location.search);
        const query = queryParams.get('query');

        if (query) {
            setSearchInput(query);
            setIsSearching(true);
            setShowAllPosts(true);
        } else {
            fetchRandomPosts();
        }
        if (savedSortOption) {
            setSortOption(savedSortOption);
        }
    }, [location.search]);

    const getUserId = () => {
        const authData = JSON.parse(sessionStorage.getItem("auth")) || JSON.parse(localStorage.getItem("auth"));
        return authData ? authData.id : null;
    };

    const fetchRandomPosts = async () => {
        try {
            const response = await axios.get('http://localhost:5000/api/TopPosts');
            setPosts(response.data);
            setSortedPosts(response.data);
            setShowAllPosts(false);
        } catch (error) {
            console.error('Error fetching top posts:', error.message);
        }
    };

    const fetchPosts = async () => {
        try {
            const response = await axios.get('http://localhost:5000/api/posts');
            const allPosts = response.data;
            setPosts(allPosts);
            setSortedPosts(allPosts);
        } catch (error) {
            console.error('Error fetching posts:', error);
        }
    };

    const searchPosts = async (query, sortOptionParam = sortOption) => {
        const queryParams = new URLSearchParams({ query });

        try {
            const response = await axios.get(`http://localhost:5000/api/searchPosts?${queryParams.toString()}`);
            let searchedPosts = response.data;

            if (sortOptionParam !== 'default') {
                searchedPosts = await sortPosts(searchedPosts, sortOptionParam);
            }

            setPosts(searchedPosts);
            setSortedPosts(searchedPosts);
        } catch (error) {
            console.error('Error searching posts:', error);
        }
    };

    const sortPosts = async (posts, sortOptionParam = sortOption) => {
        const ids = posts.map(post => post.IdPost);

        if (ids.length === 0) return posts;

        try {
            const response = await axios.post(`http://localhost:5000/api/sortPosts`, {
                ids,
                option: sortOptionParam
            });
            return response.data;
        } catch (error) {
            console.error('Error sorting posts:', error);
            return posts;
        }
    };

    const handleSeeAllPosts = () => {
        fetchPosts();
        setShowAllPosts(true);
    };

    const handleChange = (e) => {
        const { value } = e.target;
        setSearchInput(value);
        setIsSearching(value.trim() !== '');
        setShowAllPosts(true);

        const queryParams = new URLSearchParams(location.search);
        queryParams.set('query', value);
        window.history.replaceState({}, '', `${window.location.pathname}?${queryParams.toString()}`);

        if (!value.trim()) {
            fetchRandomPosts();
        } else {
            searchPosts(value);
            setShowAllPosts(true);
        }
    };

    const handleSortChange = async (e) => {
        const { value } = e.target;
        setSortOption(value);
        sessionStorage.setItem('sortOption', value);
        const ids = posts.map(post => post.IdPost);

        if (value === 'default') {
            setSortedPosts(posts);
            return;
        }
        try {
        const response = await axios.post(`http://localhost:5000/api/sortPosts`, {
            ids,
            option: value
        });
        setSortedPosts(response.data);
    } catch (error) {
        console.error('Error sorting posts:', error.message);
    }
    };

    const clearSearch = () => {
        setSearchInput('');
        setIsSearching(false);
        setShowAllPosts(false);
        setSortOption('default');
        sessionStorage.removeItem('sortOption');
        fetchRandomPosts();
        const queryParams = new URLSearchParams(location.search);
        queryParams.delete('query');
        window.history.replaceState({}, '', `${window.location.pathname}?${queryParams.toString()}`);
    };

    const handleSuccess = () => {
        setAlertMessage('Post submitted successfully!');
        setTimeout(() => {
        window.location.reload();
        }, 1000);
    };

    const handleFailure = () => {
        setAlertMessage('Authentication failed. Please log in and try again.');
        setTimeout(() => {
        window.location.reload();
        }
        , 1000);
    };

    const handleAddPostButtonClick = () => {
        if (getUserId()) {
            setIsPostModalVisible(true);
        } else {
            setAlertMessage('You need to log in to post.');
        }
        setIsReAuthVisible(true);
    };

    const handleReAuthComplete = () => {
        const userId = getUserId();
        if (userId) {
            setIsPostModalVisible(true);
        } else {
            setIsPostModalVisible(false);
            setAlertMessage('You need to log in to post.');
        }
        setIsReAuthVisible(false);
    };



    return (
        <div>
            <Navbar />
            <main className="page-content">
                <div className="search-container">
                    <input
                        type="search"
                        placeholder="Search posts"
                        value={searchInput}
                        onChange={handleChange}
                        className="search-input"
                    />
                    <button className="clear-button" onClick={clearSearch}><FontAwesomeIcon icon={faTimes} /></button>
                    <select onChange={handleSortChange} value={sortOption} className="sort-dropdown">
                        <option value="default">Order by</option>
                        <option value="byRepliesLessToMore">Number of Replies: Less to More</option>
                        <option value="byRepliesMoreToLess">Number of Replies: More to Less</option>
                        <option value="byDateRecent">Release Date: More Recent to Less</option>
                        <option value="byDateLessRecent">Release Date: Less Recent to More</option>
                    </select>
                </div>
                <div className="new-post-container">
                    <button
                    className="bg-red-600 text-white py-2 px-4 rounded-md hover:bg-red-700 w-full mt-4"
                    onClick={handleAddPostButtonClick}
                    >Add Post</button>
                </div>
                </main>
                    <div className="page-content">
                        {(isSearching) ? (
                            <h2>Search Results For: {searchInput}</h2>
                        ) : (
                            <h2>Find Posts</h2>
                        )}
                        <div className="posts-container">
                            {sortedPosts.length > 0 ? (
                                sortedPosts.map((post) => (
                                <Post key={post.IdPost} post={post} />
                            ))
                        ) : (
                            <div className='no-posts'>
                            <p>No matching posts found.</p>
                            </div>
                            )}
                        </div>
                    {!showAllPosts && (
                <button className="see-all-button" onClick={handleSeeAllPosts}>See All Posts</button>
            )}
            </div>
            <Footer />
            <PostModal isVisible={isPostModalVisible} onClose={() => setIsPostModalVisible(false)} onFailure={handleFailure} onSuccess={handleSuccess}/>
            {alertMessage && <AlertModal message={alertMessage} onClose={() => setAlertMessage('')} />}
            {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
        </div>
    );
}

function Post({ post }) {
    const [showReplies, setShowReplies] = useState(false);
    const [replies, setReplies] = useState([]);
    const [content, setContent] = useState('');
    const [errorMessage, setErrorMessage] = useState('');
    const [isReAuthVisible, setIsReAuthVisible] = useState(false);
    const [currentAction, setCurrentAction] = useState(null);
    const [alertMessage, setAlertMessage] = useState('');
    const [isPostModalVisible, setIsPostModalVisible] = useState(false);
    const [selectedPost, setSelectedPost] = useState(null);
    const [postToDelete, setPostToDelete] = useState(null);
    const [isDeletePostModalVisible, setIsDeletePostModalVisible] = useState(false);
    const [selectedReply, setSelectedReply] = useState(null);
    const [replyToDelete, setReplyToDelete] = useState(null);
    const [isDeleteReplyModalVisible, setIsDeleteReplyModalVisible] = useState(false);
    const [isEditReplyModalVisible, setIsEditReplyModalVisible] = useState(false);
    const [PostUserVote, setPostUserVote] = useState(0);
    const IDpost = post.IdPost;
    
    const getUserId = () => {
        const authData = JSON.parse(sessionStorage.getItem("auth")) || JSON.parse(localStorage.getItem("auth"));
        return authData ? authData.id : null;
    };

    const userId = getUserId();


    const fetchPostVote = useCallback(async () => {
        try {
            const postID = post.IdPost
            const response = await axios.get(`http://localhost:5000/api/getPostVote/${postID}/${userId}`);
            const userVote = response.data.userVote;
            setPostUserVote(userVote);
            console.log('User vote:', userVote);
        } catch (error) {
            console.error('Error fetching post vote:', error);
        }
    }, [post.IdPost, userId]);

    const fetchReplies = useCallback(async () => {
        try {
            const response = await axios.get(`http://localhost:5000/api/replies/${post.IdPost}` );
            const allReplies = response.data;
            setReplies(allReplies);

        const fetchRepliesVotes = allReplies.map(async (reply) => {
            const replyID = reply.ID
            const voteResponse = await axios.get(`http://localhost:5000/api/getReplyVote/${replyID}/${userId}`);
            const userVote = voteResponse.data.userVote;
            console.log('User vote for reply', replyID, ':', userVote);
            return { ...reply, UserVote: userVote };
        });

        const repliesWithVotes = await Promise.all(fetchRepliesVotes);

        console.log('Replies with votes:', repliesWithVotes);

        setReplies(repliesWithVotes);

        } catch (error) {
            console.error('Error fetching replies and votes:', error);
        }
    }, [post.IdPost, userId]);

    useEffect(() => {
        fetchPostVote();
        fetchReplies();
    }, [fetchPostVote,fetchReplies]);

    const handleToggleReplies = () => {
        fetchReplies();
        setShowReplies(!showReplies);
    };

    const handleButtonClick = () => {
        setIsReAuthVisible(true);
    };

    const handleReAuthComplete = () => {
        if (userId && currentAction) {
            currentAction();
        } else {
            setAlertMessage('You need to log in to reply.');
        }
        setIsReAuthVisible(false);
    };
    
    const handleSuccess = () => {
        setAlertMessage('Reply submitted successfully!');
        setTimeout(() => {
        window.location.reload();
        }, 1000);
    };

    const handleFailure = () => {
        setAlertMessage('Authentication failed. Please log in and try again.');
        setTimeout(() => {
        window.location.reload();
        }
        , 1000);
    };

    const handleAddReply = async () => {
        if (!userId) {
        setErrorMessage('User not authenticated.');
        return;
        }
        try {
            const response = await axios.post(`http://localhost:5000/api/posts/Addreplies`, {
                IdPost: IDpost,
                content,
                userID: userId
            });
        if (response.data.success) {
            setErrorMessage('');
            setTimeout(() => {
                window.location.reload();
            }, 1000);
            handleSuccess();
        } else {
            setErrorMessage(response.data.message);
        }} catch (error) {
            handleFailure();
            console.error('Error submitting post:', error);
            setErrorMessage('An error occurred. Please try again.');
        }
    };

    const handleUpvote = async (replyId) => {
        handleButtonClick();
        setCurrentAction(() => () => upvote(replyId));
        if (getUserId()) {
        } else {
            setAlertMessage('You need to log in to upvote replies.');
            setIsReAuthVisible(true);
        }
    };

    const upvote = async (replyId) => {
        try {
            const response = await axios.post('http://localhost:5000/api/upvoteReply', { replyId, userId });
            const message = response.data.message;
            console.log('message',response.data.message)
            setAlertMessage(message);
            if (message.includes('successfully') || message.includes('changed') || message.includes('removed')) {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }
        } catch (error) {
            console.error('Error upvoting reply:', error);
            alert('An error occurred. Please try again.');
        }
    };

    const handleDownvote = async (replyId) => {
        handleButtonClick();
        setCurrentAction(() => () => downvote(replyId));
        if (getUserId()) {
        } else {
            setAlertMessage('You need to log in to downvote replies.');
            setIsReAuthVisible(true);
        }
    };

    const downvote = async (replyId) => {
        try {
            console.log('replyid',replyId);
            console.log('userid',getUserId());
            const response = await axios.post('http://localhost:5000/api/downvoteReply', { replyId, userId });
            const message = response.data.message;
            setAlertMessage(message);
            if (message.includes('successfully') || message.includes('changed') || message.includes('removed')) {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }
        } catch (error) {
            console.error('Error downvoting reply:', error);
            alert('An error occurred. Please try again.');
        }
    };

    const handleReplyEditClick = (reply) => {
        handleButtonClick();
        setSelectedReply(reply);
        setCurrentAction(() => () => {
            setIsEditReplyModalVisible(true);
        });
        if (getUserId()) {
        } else {
            setAlertMessage('You need to log in to edit posts.');
            setIsReAuthVisible(true);
        }
    };
    
    const handleReplyEditSuccess = () => {
        setAlertMessage('Reply updated successfully!');
        setTimeout(() => {
        window.location.reload();
        }, 1000);
    };

    const handleReplyDeleteClick = (reply) => {
        handleButtonClick();
        setReplyToDelete(reply);
        setCurrentAction(() => confirmReplyDelete);
        if (getUserId()) {
            setIsDeleteReplyModalVisible(true);
        } else {
            setAlertMessage('You need to log in to delete posts.');
            setIsReAuthVisible(true);
        }
    };

    const confirmReplyDelete = async () => {
        if (!replyToDelete) return;
        try {
            const response = await axios.post('http://localhost:5000/api/deleteReply', { replyID: replyToDelete.ID, userID: userId });
            if (response.data.message === 'Reply deleted successfully!') {
            setIsDeleteReplyModalVisible(false);
            setReplyToDelete(null);
            window.location.reload();
        } else {
            alert(response.data.message);
        }
        } catch (error) {
            console.error('Error deleting reply:', error);
            alert('An error occurred. Please try again.');
        }
    };
    
    const cancelReplyDelete = () => {
        setIsDeleteReplyModalVisible(false);
        setReplyToDelete(null);
    };

    const handlePostUpvote = async (IDpost) => {
        handleButtonClick();
        setCurrentAction(() => () => upvotePost(IDpost));
        if (getUserId()) {
        } else {
            setAlertMessage('You need to log in to upvote posts.');
            setIsReAuthVisible(true);
        }
    };

    const upvotePost = async (IDpost) => {
        try {
            const response = await axios.post('http://localhost:5000/api/upvotePost', { IDpost, userId });
            const message = response.data.message;
            console.log('message',response.data.message)
            setAlertMessage(message);
            if (message.includes('successfully') || message.includes('changed') || message.includes('removed')) {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }
        } catch (error) {
            console.error('Error upvoting post:', error);
            alert('An error occurred. Please try again.');
        }
    };

    const handlePostDownvote = async (IDpost) => {
        handleButtonClick();
        setCurrentAction(() => () => downvotePost(IDpost));
        if (getUserId()) {
        } else {
            setAlertMessage('You need to log in to downvote posts.');
            setIsReAuthVisible(true);
        }
    };

    const downvotePost = async (IDpost) => {
        try {
            console.log('postid', IDpost);
            console.log('userid', getUserId());
            const response = await axios.post('http://localhost:5000/api/downvotePost', { IDpost, userId });
            const message = response.data.message;
            console.log(message);
            setAlertMessage(message);
            if (message.includes('successfully') || message.includes('changed') || message.includes('removed')) {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }

        } catch (error) {
            console.error('Error downvoting post:', error);
            alert('An error occurred. Please try again.');
        }
    };

    const handleEditClick = (post) => {
        handleButtonClick();
        setSelectedPost(post);
        setCurrentAction(() => () => {
        setIsPostModalVisible(true);
        });
        if (getUserId()) {
            setIsPostModalVisible(true);
        } else {
            setAlertMessage('You need to log in to edit posts.');
            setIsReAuthVisible(true);
        }
    };
    
    const handleEditSuccess = () => {
        setIsPostModalVisible(false);
        setAlertMessage('Post updated successfully!');
        setTimeout(() => {
        window.location.reload();
        }, 1000);
    };

    const handleDeleteClick = (post) => {
        handleButtonClick();
        setPostToDelete(post);
        setCurrentAction(() => confirmDelete);
        if (getUserId()) {
            setIsDeletePostModalVisible(true);
        } else {
            setAlertMessage('You need to log in to delete posts.');
            setIsReAuthVisible(true);
        }
    };

    const confirmDelete = async () => {
        if (!postToDelete) return;
        try {
            const response = await axios.post('http://localhost:5000/api/deletePost', { postID: postToDelete.IdPost, userID: userId });
            if (response.data.message === 'Post deleted successfully!') {
            setIsDeletePostModalVisible(false);
            setPostToDelete(null);
            window.location.reload();
        } else {
            alert(response.data.message);
        }
        } catch (error) {
            console.error('Error deleting post:', error);
            alert('An error occurred. Please try again.');
        }
    };
    
    const cancelDelete = () => {
        setIsDeletePostModalVisible(false);
        setPostToDelete(null);
    };


    return (
        <div className="post-card">
            <p className="font-semibold">
            {post.NomeUtilizadorPost}
            {parseInt(post.IDPostUtilizador,10) === getUserId() && (
            <span className="ml-2">
                    <button
                        className="text-blue-500 hover:text-blue-700 mr-2"
                        onClick={() => handleEditClick(post)}
                    >
                        <FontAwesomeIcon icon={faEdit} />
                    </button>
                    <button
                        className="text-red-500 hover:text-red-700"
                        onClick={() => handleDeleteClick(post)}
                    >
                        <FontAwesomeIcon icon={faTrashAlt} />
                    </button>
            </span>
            )}
            </p>
            <p className="text-gray-400 text-sm">{post.Data_post} at {post.PostHora}</p>
            <p className="text-gray-800">Title: {post.PostTitulo}</p>
            <p className="text-gray-600">{post.PostTexto}</p>
            <br/>
            <div className="flex items-center">
                <button className={`mr-2 ${PostUserVote === 1 ? 'text-green-500' : 'text-gray-500'} hover:text-green-700`} onClick={() => handlePostUpvote(post.IdPost)}>
                <FontAwesomeIcon icon={faThumbsUp} /> {post.Upvotes}
                </button>
                <button className={`${PostUserVote === -1 ? 'text-red-500' : 'text-gray-500'} hover:text-red-700`} onClick={() => handlePostDownvote(post.IdPost)}>
                <FontAwesomeIcon icon={faThumbsDown} /> {post.Downvotes}
                </button>
            </div>
            <p className="text-gray-400">Number of replies: {post.NumRespostas}</p>
            <button onClick={handleToggleReplies}>
                {showReplies ? 'Hide Replies' : 'Show Replies'}
            </button>
            {showReplies && (
                <div className="replies-container">
                    {replies.map(reply => (
                        <div key={reply.ID} className="reply">
                        <p className="font-semibold">
                        {reply.Nome}
                        {parseInt(reply.Utilizador_ID,10) === getUserId() && (
                        <span className="ml-2">
                            <button
                            className="text-blue-500 hover:text-blue-700 mr-2"
                            onClick={() => handleReplyEditClick(reply)}
                            >
                            <FontAwesomeIcon icon={faEdit} />
                            </button>
                            <button
                            className="text-red-500 hover:text-red-700"
                            onClick={() => handleReplyDeleteClick(reply)}
                            >
                            <FontAwesomeIcon icon={faTrashAlt} />
                            </button>
                        </span>
                        )}
                            </p>
                            <p className="text-gray-400 text-sm">{reply.Data_reposta} at {reply.Hora}</p>
                            <p className="text-gray-600">{reply.Texto}</p>
                            <div className="flex items-center">
                                <button className={`mr-2 ${reply.UserVote === 1 ? 'text-black-500' : 'text-gray-500'} hover:text-green-700`} onClick={() => handleUpvote(reply.ID)}>
                                <FontAwesomeIcon icon={faThumbsUp} /> {reply.Upvotes}
                                </button>
                                <button className={`${reply.UserVote === -1 ? 'text-red-500' : 'text-gray-500'} hover:text-red-700`} onClick={() => handleDownvote(reply.ID)}>
                                <FontAwesomeIcon icon={faThumbsDown} /> {reply.Downvotes}
                                </button>
                            </div>
                        </div>
                    ))}
                    <textarea
                        value={content}
                        onChange={(e) => setContent(e.target.value)}
                        placeholder="Write a reply"
                    />
                    {errorMessage && <p className="text-red-500 text-sm mb-4">{errorMessage}</p>}
                    <button onClick={handleAddReply}>Add Reply</button>
                </div>
            )}
        {alertMessage && <AlertModal message={alertMessage} onClose={() => setAlertMessage('')} />}
        {isReAuthVisible && <ReAuth onReAuthComplete={handleReAuthComplete} />}
        <PostModal
        isVisible={isPostModalVisible}
        onClose={() => setIsPostModalVisible(false)}
        onFailure={handleFailure}
        onSuccess={handleEditSuccess}
        post={selectedPost}/>
        <DeletePostConfirmationModal
        isVisible={isDeletePostModalVisible}
        post={postToDelete}
        onConfirm={confirmDelete}
        onCancel={cancelDelete}
        />
        <DeleteReplyConfirmationModal
        isVisible={isDeleteReplyModalVisible}
        reply={replyToDelete}
        onConfirm={confirmReplyDelete}
        onCancel={cancelReplyDelete}
        />
        <EditReplyModal
        isVisible={isEditReplyModalVisible}
        reply={selectedReply}
        onClose={() => setIsEditReplyModalVisible(false)}
        onSuccess={handleReplyEditSuccess}
        onFailure={handleFailure}
        onCancel={cancelReplyDelete}
        />
        </div>
        
    );
}

export default CommunityPage;