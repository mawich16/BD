console.clear();

const express = require('express');
const cors = require('cors');
const connectDB = require('./dbConfig');
const sql = require('mssql');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const startServer = async () => {
    const pool = await connectDB();
    if (!pool) {
        console.error('Failed to connect to the database. Exiting...');
        process.exit(1);
    }

    app.get('/api/topRatedGames', async (req, res) => {
        const { numberOfGames } = req.query;
        if (!numberOfGames || isNaN(numberOfGames)) {
            return res.status(400).send('NumberOfGames parameter is required and must be a number');
        }

        try {
            const result = await pool.request()
                .input('NumberOfGames', sql.Int, numberOfGames)
                .execute('sp_TopRatedGames');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching top rated games:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/randomGames', async (req, res) => {
        try {
            const result = await pool.request().execute('sp_JogosAleatorios');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching random Games:', err.message);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/searchGames', async (req, res) => {
        const { query, genre, developer, publisher, platform, filterModeRating, rating, filterModeReviews, reviews, filterModeYear, year, month, day } = req.query;
    
        if (!query) {
            return res.status(400).send('Query parameter is required');
        }
    
        let sqlQuery = `SELECT * FROM infoJogo WHERE Nome LIKE '%' + @query + '%'`;
        
        if (genre) {
            sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarGenero('${genre}'))`;
        }
        if (developer) {
            sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarDesenvolvedora('${developer}'))`;
        }
        if (publisher) {
            sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarEditora('${publisher}'))`;
        }
        if (platform) {
            sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarPlataforma('${platform}'))`;
        }
        if (rating) {
            if (filterModeRating === '>') {
                sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarRatingGreater('${rating}'))`;
            } else {
                sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarRatingLess('${rating}'))`;
            }
        }
        if (reviews) {
            if (filterModeReviews === '>') {
                sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarReviewsGreater('${reviews}'))`;
            } else {
                sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarReviewsLess('${reviews}'))`;
            }
        }
        if (year) {
            if (filterModeYear === '>') {
                sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarDataLancamentoGreater(${year}, ${month || 'NULL'}, ${day || 'NULL'}))`;
            } else {
                sqlQuery += ` AND ID IN (SELECT ID FROM udf_FiltrarDataLancamentoLess(${year}, ${month || 'NULL'}, ${day || 'NULL'}))`;
            }
        }
    
        try {
            const result = await pool.request()
                .input('query', sql.NVarChar, query)
                .query(sqlQuery);
            res.json(result.recordset);
        } catch (err) {
            console.error('Error searching games:', err);
            res.status(500).send('Server Error');
        }
    });

    
    app.get('/api/game/:id', async (req, res) => {
        const { id } = req.params;
        if (!id) {
            return res.status(400).send('Game ID is required');
        }
    
        try {
            const result = await pool.request()
                .input('GameID', sql.Int, id)
                .execute('sp_GameInfo');
            if (result.recordset.length === 0) {
                return res.status(404).send('Game not found');
            }
            res.json(result.recordset[0]);
        } catch (err) {
            console.error('Error fetching game details:', err);
            res.status(500).send('Server Error');
        }
    });
    
    app.get('/api/reviews/:gameId/:userId?', async (req, res) => {
        const { gameId, userId } = req.params;
    
        try {
            let result;
            if (userId) {
                result = await pool.request()
                    .input('GameID', sql.Int, gameId)
                    .input('UserID', sql.Int, userId)
                    .execute('sp_ObterVotoReview');
            } else {
                result = await pool.request()
                    .input('gameid', sql.Int, gameId)
                    .query('SELECT * FROM udf_Reviews(@gameid) ORDER BY Data_review DESC, Hora DESC');
            }
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching reviews:', err);
            res.status(500).send('Server Error');
        }
    });    

    app.get('/api/dlcs/:gameId', async (req, res) => {
        const { gameId } = req.params;
    
        if (!gameId) {
            return res.status(400).send('Game ID is required');
        }
    
        try {
            const result = await pool.request()
                .input('gameid', sql.Int, gameId)
                .query('SELECT * FROM udf_DLC(@gameid)');
            
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching DLCs:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/randomCompanies', async (req, res) => {
        try {
            const result = await pool.request().execute('sp_EmpresasAleatorias');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching random companies:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/searchSecondaryCompanies', async (req, res) => {
        const { query } = req.query;
    
        if (!query) {
            return res.status(400).send('Query parameter is required');
        }
        
        try {
            const result = await pool.request()
                .input('query', sql.NVarChar, query)
                .execute('sp_jogoEmpresas');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error secondary searching companies:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/searchCompanies', async (req, res) => {
        const { query } = req.query;
    
        if (!query) {
            return res.status(400).send('Query parameter is required');
        }

        try {
            const result = await pool.request()
                .input('query', sql.NVarChar, query)
                .execute('sp_Pesquisarempresas');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error searching companies:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/searchPosts', async (req, res) => {
        const { query } = req.query;
    
        if (!query) {
            return res.status(400).send('Query parameter is required');
        }

        try {
            const result = await pool.request()
                .input('query', sql.NVarChar, query)
                .execute('sp_PesquisarPosts');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error searching posts:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/replies/:IdPost', async (req, res) => {
        const { IdPost } = req.params;
    
        if (!IdPost) {
            return res.status(400).send('Post ID is required');
        }
    
        try {
            const result = await pool.request()
                .input('id', sql.Int, IdPost)
                .query('SELECT * FROM udf_respostas(@id)');
            
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching replies:', err);
            res.status(500).send('Server Error');
        }
    });

    
    app.get('/api/TopPosts', async (req, res) => {
        try {
            const result = await pool.request().execute('sp_PostsTop10');
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching random posts:', err);
            res.status(500).send('Server Error');
            console.error('erro')
        }
    });

    app.get('/api/:table', async (req, res) => {
        const { table } = req.params;
        const allowedTables = [
            'GameVault_Jogo',
            'GameVault_Utilizador',
            'GameVault_Review',
            'GameVault_Post',
            'GameVault_Resposta',
            'GameVault_Empresa',
            'GameVault_Editora',
            'GameVault_Desenvolvedora',
            'GameVault_Plataforma',
            'GameVault_DLC',
            'GameVault_Genero',
            'GameVault_Loja',
            'GameVault_Publica',
            'GameVault_Desenvolve',
            'GameVault_Vende',
            'GameVault_Jogo_Genero',
            'GameVault_Disponibiliza',
            'nomeDesenvolvedora',
            'nomeEditora',
            'infoJogo',
            'empresaInfo',
            'posts',
            'postsReplies',
            'GameVault_Review_Utilizador_Voto'
        ];

        if (!allowedTables.includes(table)) {
            return res.status(400).send('Invalid table name');
        }

        try {
            const result = await pool.request().query(`SELECT * FROM ${table}`);
            res.json(result.recordset);
        } catch (err) {
            console.error(`Error fetching data from ${table}:`, err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/sortPosts', async (req, res) => {
        let { ids, option } = req.body;
    
        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).send('IDs parameter is required and must be an array');
        }

        ids = ids.map(id => String(id).split('-')[0]);

        let spName;
        switch (option) {
            case 'byRepliesLessToMore':
                spName = 'sp_OrdemCrescenteReplies';
                break;
            case 'byRepliesMoreToLess':
                spName = 'sp_OrdemDecrescenteReplies';
                break;
            case 'byDateRecent':
                spName = 'sp_OrdemDataDescPosts';
                break;
            case 'byDateLessRecent':
                spName = 'sp_OrdemDataPosts';
                break;
            default:
                return res.status(400).send('Invalid sort option');
        }
    
        try {
            const result = await pool.request()
                .input('ids', sql.NVarChar, ids.join(','))
                .execute(spName);
            res.json(result.recordset);
        } catch (err) {
            console.error('Error sorting posts:', err);
            res.status(500).send('Server Error');
        }
    });


    app.post('/api/sortCompanies', async (req, res) => {
        let { ids, option } = req.body;

        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).send('IDs parameter is required and must be an array');
        }

        ids = ids.map(id => id.split('-')[0]);

        let spName;
        switch (option) {
            case 'byEditors':
                spName = 'sp_EmpresasEditoras';
                break;
            case 'byDevelopers':
                spName = 'sp_EmpresasDesenvolvedoras';
                break;
            case 'byPlataforma':
                spName = 'sp_EmpresasPlataformas';
                break;
            case 'byLoja':
                spName = 'sp_EmpresasLojas';
                break;
            default:
                return res.status(400).send('Invalid sort option');
        }

        try {
            const result = await pool.request()
                .input('ids', sql.NVarChar, ids.join(','))
                .execute(spName);
            res.json(result.recordset);
        } catch (err) {
            console.error('Error sorting companies:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/companyDetails/:id/:type', async (req, res) => {
        const { id, type } = req.params;
    
        let udfName;
        switch (type) {
            case 'E':
                udfName = 'udf_editoraJogos';
                break;
            case 'D':
                udfName = 'udf_desenvolvedoraJogos';
                break;
            case 'P':
                udfName = 'udf_plataformaJogos';
                break;
            case 'L':
                udfName = 'udf_lojaJogos';
                break;
            default:
                return res.status(400).send('Invalid type');
        }
    
        try {
            const result = await pool.request()
            .input('id', sql.Int, id)
            .query(`SELECT * FROM ${udfName}(@id)`);
            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching company details:', err);
            res.status(500).send('Server Error');
        }
    });

    app.get('/api/companyInfo/:id/:type', async (req, res) => {
        const { id, type } = req.params;
        const udfName = 'udf_empresaInfo';

        try {
            const request = pool.request();
            request.input('id', sql.Int, id);
            request.input('type', sql.VarChar(10), type);

            const query = `SELECT * FROM ${udfName}(@id, @type)`;

            const result = await request.query(query);

            res.json(result.recordset);
        } catch (err) {
            console.error('Error fetching company details:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/authenticate', async (req, res) => {
        const { email, password, staySignedIn } = req.body;
        try {
            const result = await pool.request()
                .input('Email', sql.VarChar, email)
                .input('Password', sql.VarChar, password)
                .input('StaySignedIn', sql.Bit, staySignedIn)
                .output('Token', sql.VarChar(255))
                .output('TokenExpiration', sql.DateTime)
                .output('ErrorMessage', sql.NVarChar(255))
                .output('Username', sql.VarChar(120))
                .output('ID', sql.Int)
                .execute('sp_AutenticarUtilizador');
    
            const errorMessage = result.output.ErrorMessage;
            const token = result.output.Token;
            const username = result.output.Username;
            const tokenExpiration = result.output.TokenExpiration;
            const id = result.output.ID;
    
            if (token) {
                res.json({ success: true, token, tokenExpiration, username, id });
            } else {
                res.json({ success: false, message: errorMessage });
            }
        } catch (err) {
            console.error('Error authenticating user:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/register', async (req, res) => {
        const { username, password, email } = req.body;
        try {
            const result = await pool.request()
                .input('Username', sql.VarChar, username)
                .input('Password', sql.VarChar, password)
                .input('Email', sql.VarChar, email)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_InserirUtilizador');
            
            const errorMessage = result.output.ErrorMessage;
    
            if (errorMessage === 'User added successfully') {
                res.json({ success: true });
            } else {
                res.json({ success: false, message: errorMessage });
            }
        } catch (err) {
            console.error('Error registering user:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/filterGames', async (req, res) => {
        const { genre, developer, publisher, platform, filterModeRating, rating, filterModeReviews, reviews, filterModeYear, year, month, day } = req.body;
        let query = `SELECT * FROM infoJogo WHERE 1=1`;
        if (genre) {
            query += ` AND ID IN (SELECT ID FROM udf_FiltrarGenero('${genre}'))`;
        }
        if (developer) {
            query += ` AND ID IN (SELECT ID FROM udf_FiltrarDesenvolvedora('${developer}'))`;
        }
        if (publisher) {
            query += ` AND ID IN (SELECT ID FROM udf_FiltrarEditora('${publisher}'))`;
        }
        if (platform) {
            query += ` AND ID IN (SELECT ID FROM udf_FiltrarPlataforma('${platform}'))`;
        }
        if (rating) {
            if (filterModeRating === '>') {
                query += ` AND ID IN (SELECT ID FROM udf_FiltrarRatingGreater('${rating}'))`;
            } else {
                query += ` AND ID IN (SELECT ID FROM udf_FiltrarRatingLess('${rating}'))`;
            }
        }
        if (reviews) {
            if (filterModeReviews === '>') {
                query += ` AND ID IN (SELECT ID FROM udf_FiltrarReviewsGreater('${reviews}'))`;
            } else {
                query += ` AND ID IN (SELECT ID FROM udf_FiltrarReviewsLess('${reviews}'))`;
            }
        }
        if (year) {
            if (filterModeYear === '>') {
                query += ` AND ID IN (SELECT ID FROM udf_FiltrarDataLancamentoGreater(${year}, ${month || 'NULL'}, ${day || 'NULL'}))`;
            } else {
                query += ` AND ID IN (SELECT ID FROM udf_FiltrarDataLancamentoLess(${year}, ${month || 'NULL'}, ${day || 'NULL'}))`;
            }
        }

        try {
            const result = await pool.request().query(query);
            res.json(result.recordset);
        } catch (err) {
            console.error('Error filtering games:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/sortGames', async (req, res) => {
        const { ids, option } = req.body;

        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).send('IDs parameter is required and must be an array');
        }

        let spName;
        switch (option) {
            case 'alphabetical-az':
                spName = 'sp_OrdemAlfabetica';
                break;
            case 'alphabetical-za':
                spName = 'sp_OrdemAlfabeticaDesc';
                break;
            case 'year-more-recent':
                spName = 'sp_OrdemDataDesc';
                break;
            case 'year-less-recent':
                spName = 'sp_OrdemData';
                break;
            case 'reviews-more':
                spName = 'sp_OrdemNumReviewsDesc';
                break;
            case 'reviews-less':
                spName = 'sp_OrdemNumReviews';
                break;
            case 'rating-more':
                spName = 'sp_OrdemRating';
                break;
            case 'rating-less':
                spName = 'sp_OrdemRatingDesc';
                break;
            default:
                return res.status(400).send('Invalid sort option');
        }

        try {
            const result = await pool.request()
                .input('ids', sql.NVarChar, ids.join(','))
                .execute(spName);
            res.json(result.recordset);
        } catch (err) {
            console.error('Error sorting games:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/updateUserInfo', async (req, res) => {
        const { ID, username, email } = req.body;
        try {
            const result = await pool.request()
                .input('ID', sql.Int, ID)
                .input('Username', sql.VarChar, username)
                .input('Email', sql.VarChar, email)
                .output('NewToken', sql.VarChar(255))
                .output('TokenExpiration', sql.DateTime)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_UpdateUserInfo');
    
            const errorMessage = result.output.ErrorMessage;
            const newToken = result.output.NewToken;
            const tokenExpiration = result.output.TokenExpiration;
    
            if (newToken) {
                res.json({ success: true, newToken, tokenExpiration });
            } else {
                res.json({ success: false, message: errorMessage });
            }
        } catch (err) {
            console.error('Error updating user information:', err);
            res.status(500).send('Server Error');
        }
    });
    
    app.post('/api/validateToken', async (req, res) => {
        const { token } = req.body;
        try {
            const result = await pool.request()
                .input('Token', sql.VarChar, token)
                .output('ID', sql.Int)
                .execute('sp_ValidateToken');
    
            const ID = result.output.ID;
    
            if (ID) {
                res.json({ success: true, ID });
            } else {
                res.json({ success: false });
            }
        } catch (err) {
            console.error('Error validating token:', err);
            res.status(500).send('Server Error');
        }
    });
    
    app.post('/api/review', async (req, res) => {
        const { comment, ID, gameID, rating } = req.body;
        try {
            const result = await pool.request()
            .input('comment', sql.VarChar(sql.MAX), comment)
            .input('ID', sql.Int, ID)
            .input('gameID', sql.Int, gameID)
            .input('rating', sql.Decimal(2, 1), rating)
            .output('ErrorMessage', sql.NVarChar(255))
            .execute('sp_InserirReview');

            const errorMessage = result.output.ErrorMessage;

            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error submitting review:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/addPost', async (req, res) => {
        const { title, userId, content } = req.body;
        try {
            const result = await pool.request()
            .input('title', sql.VarChar(255), title)
            .input('userID', sql.Int, userId)
            .input('content', sql.VarChar(sql.MAX), content)
            .output('ErrorMessage', sql.NVarChar(255))
            .execute('sp_InserirPost');

            const errorMessage = result.output.ErrorMessage;

            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error submitting post:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/posts/Addreplies', async (req, res) => {
        const { IdPost, content, userID } = req.body;

        try {
            const result = await pool.request()
            .input('postID', sql.Int, IdPost)
            .input('content', sql.VarChar(sql.MAX), content)
            .input('userID', sql.Int, userID)
            .output('ErrorMessage', sql.NVarChar(255))
            .execute('sp_InserirResposta');

            const errorMessage = result.output.ErrorMessage;

            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error submitting reply:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/editReview', async (req, res) => {
        const { reviewID, userID, comment, rating } = req.body;
        try {
            const result = await pool.request()
                .input('ReviewID', sql.Int, reviewID)
                .input('UserID', sql.Int, userID)
                .input('Comment', sql.VarChar(sql.MAX), comment)
                .input('Rating', sql.Decimal(2, 1), rating)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_EditarReview');
    
            const errorMessage = result.output.ErrorMessage;
    
            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error editing review:', err);
            res.status(500).send('Server Error');
        }
    });
    
    app.post('/api/deleteReview', async (req, res) => {
        const { reviewID, userID } = req.body;
        try {
            const result = await pool.request()
                .input('ReviewID', sql.Int, reviewID)
                .input('UserID', sql.Int, userID)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_ApagarReview');
    
            const errorMessage = result.output.ErrorMessage;
    
            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error deleting review:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/upvote', async (req, res) => {
        const { reviewID, userID } = req.body;
        try {
            const result = await pool.request()
                .input('ReviewID', sql.Int, reviewID)
                .input('UserID', sql.Int, userID)
                .output('Message', sql.NVarChar(255))
                .execute('sp_UpvoteReview');
    
            res.json({ message: result.output.Message });
        } catch (err) {
            console.error('Error upvoting review:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/downvote', async (req, res) => {
        const { reviewID, userID } = req.body;
        try {
            const result = await pool.request()
                .input('ReviewID', sql.Int, reviewID)
                .input('UserID', sql.Int, userID)
                .output('Message', sql.NVarChar(255))
                .execute('sp_DownvoteReview');
    
            res.json({ message: result.output.Message });
        } catch (err) {
            console.error('Error downvoting review:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/upvoteReply', async (req, res) => {
        const { replyId, userId } = req.body;
        try {
            const result = await pool.request()
                .input('replyID', sql.Int, replyId)
                .input('userID', sql.Int, userId)
                .output('message', sql.NVarChar(255))
                .execute('sp_UpvoteResposta');
    
            res.json({ message: result.output.message });
        } catch (err) {
            console.error('Error upvoting reply:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/downvoteReply', async (req, res) => {
        const { replyId, userId } = req.body;

        try {
            const result = await pool.request()
                .input('replyID', sql.Int, replyId)
                .input('userID', sql.Int, userId)
                .output('message', sql.NVarChar(255))
                .execute('sp_DownvoteResposta');
    
            res.json({ message: result.output.message });
        } catch (err) {
            console.error('Error downvoting reply:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/upvotePost', async (req, res) => {
        const { IDpost, userId } = req.body;
        try {
            const result = await pool.request()
                .input('postID', sql.Int, IDpost)
                .input('userID', sql.Int, userId)
                .output('message', sql.NVarChar(255))
                .execute('sp_UpvotePost');
    
            res.json({ message: result.output.message });
        } catch (err) {
            console.error('Error upvoting post:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/downvotePost', async (req, res) => {
        const { IDpost, userId } = req.body;
        try {
            const result = await pool.request()
                .input('postID', sql.Int, IDpost)
                .input('userID', sql.Int, userId)
                .output('message', sql.NVarChar(255))
                .execute('sp_DownvotePost');
    
            res.json({ message: result.output.message });
        } catch (err) {
            console.error('Error downvoting post:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/editPost', async (req, res) => {
        const { postID, userID, content, title } = req.body;
        try {
            const result = await pool.request()
                .input('postID', sql.Int, postID)
                .input('userID', sql.Int, userID)
                .input('text', sql.VarChar(sql.MAX), content)
                .input('title', sql.VarChar(225), title)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_EditarPost');
    
            const errorMessage = result.output.ErrorMessage;
    
            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error editing post:', err);
            res.status(500).send('Server Error');
        }
    });
    
    app.post('/api/deletePost', async (req, res) => {
        const { postID, userID } = req.body;
        try {
            const result = await pool.request()
                .input('postID', sql.Int, postID)
                .input('userID', sql.Int, userID)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_ApagarPost');
    
            const errorMessage = result.output.ErrorMessage;
    
            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error deleting post:', err);
            res.status(500).send('Server Error');
        }
    });

    app.post('/api/editReply', async (req, res) => {
        const { replyID, content, userId } = req.body;
        console.log('xxx')
        try {
            const result = await pool.request()
                .input('replyID', sql.Int, replyID)
                .input('userID', sql.Int, userId)
                .input('text', sql.VarChar(sql.MAX), content)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_EditarResposta');
    
            const errorMessage = result.output.ErrorMessage;
            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error editing reply:', err);
            res.status(500).send('Server Error');
            
        }
    });
    
    app.post('/api/deleteReply', async (req, res) => {
        const { replyID, userID } = req.body;
        try {
            const result = await pool.request()
                .input('replyID', sql.Int, replyID)
                .input('userID', sql.Int, userID)
                .output('ErrorMessage', sql.NVarChar(255))
                .execute('sp_ApagarResposta');
    
            const errorMessage = result.output.ErrorMessage;
    
            res.json({ message: errorMessage });
        } catch (err) {
            console.error('Error deleting reply:', err);
            res.status(500).send('Server Error');
        }
    });

app.get('/api/getReplyVote/:replyID/:userId', async (req, res) => {
    const { replyID, userId } = req.params;
    try {
        const result = await pool.request()
            .input('replyID', sql.Int, replyID)
            .input('userID', sql.Int, userId)
            .query('SELECT dbo.udf_ObterVotoResposta(@replyID, @userID) AS UserVote');
        
        res.json({ userVote: result.recordset[0].UserVote });
    } catch (err) {
        console.error('Error fetching reply vote:', err);
        res.status(500).send('Server Error');
    }
});

app.get('/api/getPostVote/:postID/:userId', async (req, res) => {
    const { postID, userId } = req.params;
    try {
        const result = await pool.request()
            .input('postID', sql.Int, postID)
            .input('userID', sql.Int, userId)
            .query('SELECT dbo.udf_ObterVotoPost(@postID, @userID) AS UserVote');
        
        res.json({ userVote: result.recordset[0].UserVote });
    } catch (err) {
        console.error('Error fetching post vote:', err);
        res.status(500).send('Server Error');
    }
    });

    app.listen(port, () => {
        console.log(`Server is running on port ${port}`);
    });
};

startServer();