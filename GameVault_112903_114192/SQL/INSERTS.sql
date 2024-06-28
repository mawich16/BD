DELETE FROM GameVault_Review_Utilizador_Voto;
DELETE FROM GameVault_Post_Utilizador_Voto;
DELETE FROM GameVault_Resposta_Utilizador_Voto;
DELETE FROM GameVault_Disponibiliza;
DELETE FROM GameVault_Jogo_Genero;
DELETE FROM GameVault_Vende;
DELETE FROM GameVault_Desenvolve;
DELETE FROM GameVault_Publica;
DELETE FROM GameVault_Loja;
DELETE FROM GameVault_Genero;
DELETE FROM GameVault_DLC;
DELETE FROM GameVault_Plataforma;
DELETE FROM GameVault_Desenvolvedora;
DELETE FROM GameVault_Editora;
DELETE FROM GameVault_Empresa;
DELETE FROM GameVault_Resposta;
DELETE FROM GameVault_Post;
DELETE FROM GameVault_Review;
DELETE FROM GameVault_Utilizador where id=1;
DELETE FROM GameVault_Jogo;
DBCC CHECKIDENT('[GameVault_Loja]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Genero]',RESEED,0);
DBCC CHECKIDENT('[GameVault_DLC]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Plataforma]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Empresa]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Resposta]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Post]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Review]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Utilizador]',RESEED,0);
DBCC CHECKIDENT('[GameVault_Jogo]',RESEED,0);



INSERT INTO GameVault_Jogo (Nome,Data_lancamento,Descricao) VALUES 
	('The Witcher 3: Wild Hunt', '2015-05-19', 'An action role-playing game set in an open world environment, developed by CD Projekt Red.'),
    ('Red Dead Redemption 2', '2018-10-26', 'A Western-themed action-adventure game developed and published by Rockstar Games.'),
    ('The Legend of Zelda: Breath of the Wild', '2017-03-03', 'An action-adventure game developed and published by Nintendo for the Nintendo Switch and Wii U consoles.'),
    ('Cyberpunk 2077', '2020-12-10', 'An open-world action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification.'),
    ('Grand Theft Auto V', '2013-09-17', 'An action-adventure game developed by Rockstar North and published by Rockstar Games.'),
    ('God of War', '2018-04-20', 'An action-adventure game developed by Santa Monica Studio and published by Sony Interactive Entertainment.'),
    ('Minecraft', '2011-11-18', 'A sandbox video game developed by Mojang Studios.'),
    ('Fortnite', '2017-07-25', 'An online video game developed by Epic Games.'),
    ('Among Us', '2018-06-15', 'An online multiplayer social deduction game developed and published by InnerSloth.'),
	('Horizon Zero Dawn', '2017-02-28', 'An action role-playing game developed by Guerrilla Games and published by Sony Interactive Entertainment.'),
    ('The Elder Scrolls V: Skyrim', '2011-11-11', 'An open-world action role-playing game developed by Bethesda Game Studios and published by Bethesda Softworks.'),
    ('Dark Souls III', '2016-04-12', 'An action role-playing game developed by FromSoftware and published by Bandai Namco Entertainment.'),
    ('Overwatch', '2016-05-24', 'A team-based multiplayer first-person shooter developed and published by Blizzard Entertainment.'),
    ('Assassins Creed Valhalla', '2020-11-10', 'An action role-playing video game developed by Ubisoft Montreal and published by Ubisoft.'),
    ('The Last of Us Part II', '2020-06-19', 'An action-adventure game developed by Naughty Dog and published by Sony Interactive Entertainment.'),
    ('Persona 5', '2016-09-15', 'A role-playing video game developed by Atlus.'),
    ('DOOM Eternal', '2020-03-20', 'A first-person shooter game developed by id Software and published by Bethesda Softworks.'),
    ('Animal Crossing: New Horizons', '2020-03-20', 'A social simulation video game developed and published by Nintendo for the Nintendo Switch.'),
    ('Stardew Valley', '2016-02-26', 'An indie farming simulation role-playing game developed by Eric "ConcernedApe" Barone.'),
	('Bloodborne', '2015-03-24', 'An action role-playing game developed by FromSoftware and published by Sony Computer Entertainment.'),
    ('Sekiro: Shadows Die Twice', '2019-03-22', 'An action-adventure game developed by FromSoftware and published by Activision.'),
    ('Ghost of Tsushima', '2020-07-17', 'An action-adventure game developed by Sucker Punch Productions and published by Sony Interactive Entertainment.'),
    ('Resident Evil Village', '2021-05-07', 'A survival horror game developed and published by Capcom.'),
    ('Hades', '2020-09-17', 'A roguelike dungeon crawler developed and published by Supergiant Games.'),
    ('Death Stranding', '2019-11-08', 'An action game developed by Kojima Productions and published by Sony Interactive Entertainment.'),
    ('Marvels Spider-Man', '2018-09-07', 'An action-adventure game developed by Insomniac Games and published by Sony Interactive Entertainment.'),
    ('Final Fantasy VII Remake', '2020-04-10', 'An action role-playing game developed and published by Square Enix.'),
    ('Genshin Impact', '2020-09-28', 'An action role-playing game developed and published by miHoYo.'),
    ('Nier: Automata', '2017-02-23', 'An action role-playing game developed by PlatinumGames and published by Square Enix.'),
	('The Last Guardian', '2016-12-06', 'An action-adventure game developed by genDESIGN and published by Sony Interactive Entertainment.'),
    ('Celeste', '2018-01-25', 'A platforming video game created by Maddy Makes Games.'),
    ('Monster Hunter: World', '2018-01-26', 'An action role-playing game developed and published by Capcom.'),
    ('Super Mario Odyssey', '2017-10-27', 'A platform game developed and published by Nintendo for the Nintendo Switch.'),
    ('Control', '2019-08-27', 'An action-adventure game developed by Remedy Entertainment and published by 505 Games.'),
    ('Ori and the Will of the Wisps', '2020-03-11', 'A platform-adventure Metroidvania video game developed by Moon Studios and published by Xbox Game Studios.'),
    ('Cuphead', '2017-09-29', 'A run and gun video game developed and published by Studio MDHR.'),
    ('Dishonored 2', '2016-11-11', 'An action-adventure game developed by Arkane Studios and published by Bethesda Softworks.'),
    ('Metal Gear Solid V: The Phantom Pain', '2015-09-01', 'An action-adventure stealth game developed by Kojima Productions and published by Konami.'),
    ('Divinity: Original Sin II', '2017-09-14', 'A role-playing video game developed and published by Larian Studios.'),
	('Bayonetta 2', '2014-09-20', 'An action-adventure hack and slash game developed by PlatinumGames and published by Nintendo.'),
    ('Hollow Knight', '2017-02-24', 'A Metroidvania action-adventure game developed and published by Team Cherry.'),
    ('Tetris Effect', '2018-11-09', 'A tile-matching puzzle game developed by Monstars and Resonair and published by Enhance Games.'),
    ('Persona 4 Golden', '2012-06-14', 'A role-playing game developed and published by Atlus for PlayStation Vita.'),
    ('Dragon Quest XI: Echoes of an Elusive Age', '2017-07-29', 'A role-playing game developed and published by Square Enix.'),
    ('Xenoblade Chronicles 2', '2017-12-01', 'An action role-playing game developed by Monolith Soft and published by Nintendo for the Nintendo Switch.'),
    ('Fire Emblem: Three Houses', '2019-07-26', 'A tactical role-playing game developed by Intelligent Systems and Koei Tecmo and published by Nintendo.'),
    ('The Outer Worlds', '2019-10-25', 'An action role-playing game developed by Obsidian Entertainment and published by Private Division.'),
    ('Apex Legends', '2019-02-04', 'A free-to-play battle royale-hero shooter game developed by Respawn Entertainment and published by Electronic Arts.'),
    ('Doom (2016)', '2016-05-13', 'A first-person shooter game developed by id Software and published by Bethesda Softworks.');

SELECT * FROM GameVault_Jogo;

INSERT INTO GameVault_Utilizador (Nome,Email,Data_adesao,[Password]) VALUES
    ('Deleted User', 'deleted@exemple.com', '2000-01-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','doesntexists'), 2)),
	('John Doe', 'john.doe@example.com', '2023-01-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','password123'), 2)), --
    ('Jane Smith', 'jane.smith@example.com', '2023-02-20', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','securepassword'), 2)), --
    ('Alice Johnson', 'alice.johnson@example.com', '2023-03-10', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','mysecretpass'), 2)), --
    ('Bob Brown', 'bob.brown@example.com', '2023-04-05', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','pass123word'), 2)), --
    ('Emily Davis', 'emily.davis@example.com', '2023-05-12', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','strongpassword'), 2)), --
	('Michael Clark', 'michael.clark@example.com', '2023-06-18', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','mypass123'), 2)), --
    ('Sarah Wilson', 'sarah.wilson@example.com', '2023-07-22', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','wilsonsecure'), 2)), --
    ('David Martinez', 'david.martinez@example.com', '2023-08-30', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','martinezpass'), 2)), --
    ('Laura Moore', 'laura.moore@example.com', '2023-09-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','mooresecure'), 2)), --
    ('James Taylor', 'james.taylor@example.com', '2023-10-08', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','taylorpass'), 2)), --
    ('Patricia Anderson', 'patricia.anderson@example.com', '2023-11-02', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','andersonpass'), 2)), --
    ('Robert Thomas', 'robert.thomas@example.com', '2023-12-12', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','thomas123'), 2)), --
    ('Linda Jackson', 'linda.jackson@example.com', '2023-12-22', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','jacksonsecure'), 2)), --
    ('Charles Harris', 'charles.harris@example.com', '2024-01-10', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','harrispass'), 2)), --
    ('Barbara Martin', 'barbara.martin@example.com', '2024-01-25', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','martinsecure'), 2)), --
	('Andrew Lee', 'andrew.lee@example.com', '2024-02-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','leeandrew123'), 2)), --
    ('Jessica White', 'jessica.white@example.com', '2024-02-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','whitejessica'), 2)), --
    ('Christopher Young', 'christopher.young@example.com', '2024-03-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','youngchris'), 2)), --
    ('Amanda King', 'amanda.king@example.com', '2024-03-12', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','kingamanda'), 2)), --
    ('Joshua Wright', 'joshua.wright@example.com', '2024-03-20', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','wrightjosh'), 2)), --
    ('Jennifer Scott', 'jennifer.scott@example.com', '2024-04-05', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','scottjennifer'), 2)), --
    ('Daniel Green', 'daniel.green@example.com', '2024-04-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','greendaniel'), 2)), --
    ('Samantha Adams', 'samantha.adams@example.com', '2024-04-28', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','adamssam'), 2)), --
    ('Matthew Nelson', 'matthew.nelson@example.com', '2024-05-10', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','nelsonmatt'), 2)), --
    ('Ashley Hill', 'ashley.hill@example.com', '2024-05-25', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','hillashley'), 2)), --
	('Paul Walker', 'paul.walker@example.com', '2024-05-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','walkerpaul'), 2)), --
    ('Elizabeth Hall', 'elizabeth.hall@example.com', '2024-05-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','halleli123'), 2)), --
    ('Steven Allen', 'steven.allen@example.com', '2024-05-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','allensteve'), 2)), --
    ('Karen Young', 'karen.young@example.com', '2024-05-10', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','youngkaren'), 2)), --
    ('Edward Hernandez', 'edward.hernandez@example.com', '2024-05-20', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','hernandezed'), 2)), --
    ('Nancy King', 'nancy.king@example.com', '2024-05-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','kingnancy'), 2)), -- posts
    ('Kevin Wright', 'kevin.wright@example.com', '2023-08-12', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','wrightkevin'), 2)), --posts
    ('Susan Lopez', 'susan.lopez@example.com', '2023-08-22', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','lopezsusan'), 2)), --posts
    ('Brian Hill', 'brian.hill@example.com', '2023-09-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','hillbrian'), 2)), --posts
    ('Margaret Scott', 'margaret.scott@example.com', '2023-09-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','scottmarg'), 2)), --posts
	('George Adams', 'george.adams@example.com', '2023-09-20', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','adamsgeorge'), 2)), --posts
    ('Betty Robinson', 'betty.robinson@example.com', '2023-10-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','robinsonbetty'), 2)), --respostas
    ('Timothy Clark', 'timothy.clark@example.com', '2023-10-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','clarktimothy'), 2)), --respostas
    ('Sandra Lewis', 'sandra.lewis@example.com', '2023-11-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','lewissandra'), 2)), --respostas
    ('Jason Walker', 'jason.walker@example.com', '2014-11-10', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','walkerjason'), 2)), --respostas
    ('Donna Harris', 'donna.harris@example.com', '2023-11-20', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','harrisdonna'), 2)), --respostas
    ('Charles Martinez', 'charles.martinez@example.com', '2023-12-01', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','martinezcharles'), 2)), --respostas
    ('Emily Wilson', 'emily.wilson@example.com', '2023-12-15', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','wilsonej'), 2)), --respostas
    ('Alexander Moore', 'alexander.moore@example.com', '2023-01-05', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','moorealex'), 2)), --respostas
    ('Stephanie Taylor', 'stephanie.taylor@example.com', '2023-01-20', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256','taylors123'), 2)); --respostas

SELECT * FROM GameVault_Utilizador;

INSERT INTO GameVault_Review (Comentario,Utilizador_ID,Data_review,Hora,Jogo_ID,Rating) VALUES
	('Awesome game, loved every bit of it!', 1, '2024-05-15', '14:30:00', 1, 5),
    ('One of the best games I''ve played recently.', 1, '2024-05-16', '10:00:00', 2, 4),
    ('A masterpiece in storytelling and gameplay.', 1, '2024-05-17', '16:45:00', 3, 5),
    ('Great graphics and engaging storyline.', 1, '2024-05-18', '19:15:00', 4, 4),
    ('Highly recommended for RPG fans.', 1, '2024-05-19', '12:00:00', 5, 5),
    ('Unique gameplay mechanics and beautiful visuals.', 2, '2024-05-20', '15:30:00', 6, 4),
    ('Challenging yet rewarding experience.', 2, '2024-05-21', '11:45:00', 7, 5),
    ('Fun multiplayer with friends.', 2, '2024-05-22', '17:00:00', 8, 4),
    ('Innovative and addictive!', 2, '2024-05-23', '09:30:00', 9, 5),
    ('Great open-world exploration.', 2, '2024-05-24', '13:45:00', 10, 4),
    ('Captivating story and characters.', 2, '2024-05-25', '18:00:00', 11, 5),
    ('Addictive gameplay, couldn''t put it down!', 2, '2024-05-26', '20:00:00', 12, 4),
    ('Excellent level design and atmosphere.', 2, '2024-05-27', '14:00:00', 13, 5),
    ('Good balance of action and strategy.', 2, '2024-05-28', '10:30:00', 14, 4),
    ('Impressive visuals and sound.', 2, '2024-05-29', '16:00:00', 15, 5),
    ('Well-crafted world with deep lore.', 3, '2024-05-30', '11:00:00', 16, 4),
    ('Amazing multiplayer experience.', 3, '2024-06-01', '15:00:00', 17, 5),
    ('Engaging combat and exploration.', 3, '2024-06-02', '12:30:00', 18, 4),
	('Loved the storyline and character development!', 4, '2024-06-26', '14:30:00', 11, 5),
    ('Great open-world experience, lots to explore.', 4, '2024-06-27', '10:00:00', 20, 4),
    ('Addictive gameplay, can''t stop playing it!', 4, '2024-06-28', '16:45:00', 35, 5),
    ('Beautiful graphics and music, very atmospheric.', 4, '2024-06-29', '19:15:00', 33, 4),
    ('Enjoyed the puzzles and challenges.', 4, '2024-06-30', '12:00:00', 37, 5),
    ('Solid gameplay mechanics, very satisfying.', 4, '2024-07-01', '15:30:00', 26, 4),
    ('A journey worth taking, highly recommend it!', 4, '2024-07-02', '11:45:00', 19, 5),
    ('Great game for strategy lovers, deep and engaging.', 4, '2024-07-03', '17:00:00', 38, 4),
	('Fantastic gameplay mechanics, very polished.', 5, '2024-07-04', '14:30:00', 7, 5),
    ('Enjoyed the multiplayer experience with friends.', 5, '2024-07-05', '10:00:00', 8, 4),
	('Absolutely stunning visuals and soundtrack!', 6, '2024-07-06', '14:30:00', 3, 5),
    ('The story was captivating, kept me hooked.', 6, '2024-07-07', '10:00:00', 10, 4),
    ('Great action sequences, very intense gameplay.', 6, '2024-07-08', '16:45:00', 12, 5),
    ('Enjoyed the strategy elements, very tactical.', 6, '2024-07-09', '19:15:00', 19, 4),
    ('A masterpiece in game design, a must-play.', 6, '2024-07-10', '12:00:00', 21, 5),
    ('The open world felt alive, lots to discover.', 6, '2024-07-11', '15:30:00', 22, 4),
    ('Incredible attention to detail, immersive world.', 6, '2024-07-12', '11:45:00', 24, 5),
	('A thrilling experience, loved every moment!', 7, '2024-07-13', '14:30:00', 2, 5),
    ('The narrative was engaging, kept me guessing.', 7, '2024-07-14', '10:00:00', 5, 4),
    ('Fantastic world-building and lore.', 7, '2024-07-15', '16:45:00', 13, 5),
    ('Enjoyed the tactical gameplay, very strategic.', 7, '2024-07-16', '19:15:00', 16, 4),
    ('A visually stunning game, great art style.', 7, '2024-07-17', '12:00:00', 23, 5),
    ('The multiplayer aspect was well-executed.', 7, '2024-07-18', '15:30:00', 31, 4),
    ('Highly immersive, felt like part of the story.', 7, '2024-07-19', '11:45:00', 32, 5),
    ('Excellent character development and dialogue.', 7, '2024-07-20', '17:00:00', 36, 4),
    ('Addictive gameplay, couldn''t put it down!', 7, '2024-07-21', '14:00:00', 39, 5),
	('The storyline was captivating, kept me engaged throughout.', 8, '2024-07-22', '14:30:00', 6, 5),
    ('Enjoyed the puzzle-solving and exploration.', 8, '2024-07-23', '10:00:00', 9, 4),
    ('Great multiplayer experience, lots of fun with friends.', 8, '2024-07-24', '16:45:00', 18, 5),
    ('Impressive graphics and smooth gameplay mechanics.', 8, '2024-07-25', '19:15:00', 25, 4),
	('Fantastic game, loved the open-world exploration.', 9, '2024-07-26', '14:30:00', 3, 5),
    ('The story was deep and emotional, left a lasting impression.', 9, '2024-07-27', '10:00:00', 14, 4),
    ('Enjoyed the strategic gameplay and character development.', 9, '2024-07-28', '16:45:00', 17, 5),
    ('Impressive graphics and smooth combat mechanics.', 9, '2024-07-29', '19:15:00', 28, 4),
    ('Addictive gameplay, couldn''t stop playing.', 9, '2024-07-30', '12:00:00', 30, 5),
    ('Great multiplayer experience, enjoyed team dynamics.', 9, '2024-07-31', '15:30:00', 34, 4),
	('Incredible storyline and character development!', 10, '2024-08-01', '14:30:00', 1, 5),
    ('The world-building was fantastic, felt immersive.', 10, '2024-08-02', '10:00:00', 4, 4),
    ('Enjoyed the exploration and side quests.', 10, '2024-08-03', '16:45:00', 15, 5),
    ('Impressive graphics and attention to detail.', 10, '2024-08-04', '19:15:00', 27, 4),
    ('Addictive gameplay loop, kept me coming back for more.', 10, '2024-08-05', '12:00:00', 29, 5),
    ('Great co-op experience, loved playing with friends.', 10, '2024-08-06', '15:30:00', 40, 4),
    ('A masterpiece in storytelling, highly recommend.', 10, '2024-08-07', '11:45:00', 41, 5),
    ('Excellent combat mechanics, very satisfying.', 10, '2024-08-08', '17:00:00', 42, 4),
    ('Beautiful art style and music, very atmospheric.', 10, '2024-08-09', '14:00:00', 43, 5),
    ('Great game for strategy lovers, deep and engaging.', 10, '2024-08-10', '11:00:00', 44, 4),
    ('The multiplayer aspect was well-implemented.', 10, '2024-08-11', '18:00:00', 45, 5),
	('Fantastic gameplay mechanics, very enjoyable!', 11, '2024-08-12', '14:30:00', 7, 5),
    ('The story was gripping, kept me hooked till the end.', 11, '2024-08-13', '10:00:00', 10, 4),
    ('Loved the open-world exploration and freedom.', 11, '2024-08-14', '16:45:00', 12, 5),
    ('Smooth combat mechanics, very satisfying.', 11, '2024-08-15', '19:15:00', 19, 4),
    ('A visually stunning game, great art style.', 11, '2024-08-16', '12:00:00', 21, 5),
    ('The story was intriguing, kept me engaged throughout.', 12, '2024-08-17', '14:30:00', 8, 5),
    ('Enjoyed the strategic elements and decision-making.', 12, '2024-08-18', '10:00:00', 11, 4),
    ('Impressive world-building and lore.', 12, '2024-08-19', '16:45:00', 13, 5),
    ('The combat mechanics were fluid and enjoyable.', 12, '2024-08-20', '19:15:00', 20, 4),
    ('A visually stunning game with great attention to detail.', 12, '2024-08-21', '12:00:00', 26, 5),
    ('Great multiplayer experience, lots of fun with friends.', 12, '2024-08-22', '15:30:00', 35, 4),
    ('The narrative was emotional, left a lasting impression.', 12, '2024-08-23', '11:45:00', 37, 5),
    ('Excellent character development and voice acting.', 12, '2024-08-24', '17:00:00', 38, 4),
    ('Addictive gameplay, couldn''t put it down!', 12, '2024-08-25', '14:00:00', 46, 5),
    ('Beautiful soundtrack, added to the immersive experience.', 12, '2024-08-26', '11:00:00', 47, 4),
    ('Challenging and rewarding gameplay mechanics.', 12, '2024-08-27', '18:00:00', 48, 5),
    ('Great game for fans of strategy and management.', 12, '2024-08-28', '16:00:00', 49, 4),
    ('Loved the story and character development.', 13, '2024-08-29', '14:30:00', 1, 5),
    ('The graphics were stunning, very immersive.', 13, '2024-08-30', '10:00:00', 3, 4),
    ('Enjoyed the exploration and side quests.', 13, '2024-08-31', '16:45:00', 16, 5),
    ('Smooth combat mechanics, very satisfying.', 13, '2024-09-01', '19:15:00', 22, 4),
    ('Addictive gameplay loop, kept me engaged.', 13, '2024-09-02', '12:00:00', 33, 5),
    ('Great co-op experience, enjoyed playing with friends.', 13, '2024-09-03', '15:30:00', 34, 4),
    ('Fantastic soundtrack, enhanced the atmosphere.', 13, '2024-09-04', '11:45:00', 42, 5),
    ('Excellent level design and puzzles.', 13, '2024-09-05', '17:00:00', 43, 4),
    ('Enjoyed the storyline and character interactions.', 14, '2024-09-06', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 14, '2024-09-07', '10:00:00', 5, 4),
    ('Smooth gameplay mechanics, very satisfying.', 14, '2024-09-08', '16:45:00', 24, 5),
    ('The graphics and art style were impressive.', 15, '2024-09-09', '14:30:00', 7, 5),
    ('The story kept me engaged from start to finish.', 15, '2024-09-10', '10:00:00', 10, 4),
    ('Enjoyed the exploration and discovery.', 15, '2024-09-11', '16:45:00', 12, 5),
    ('Smooth combat mechanics, very satisfying.', 15, '2024-09-12', '19:15:00', 19, 4),
	('Great storyline, kept me engaged throughout.', 16, '2024-09-13', '14:30:00', 6, 5),
    ('The graphics were impressive, very detailed.', 16, '2024-09-14', '10:00:00', 9, 4),
    ('Enjoyed the exploration and atmosphere.', 16, '2024-09-15', '16:45:00', 14, 5),
    ('Smooth combat mechanics, very satisfying.', 16, '2024-09-16', '19:15:00', 18, 4),
    ('Addictive gameplay loop, kept me hooked.', 16, '2024-09-17', '12:00:00', 25, 5),
    ('Loved the story and character development.', 17, '2024-09-18', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 17, '2024-09-19', '10:00:00', 5, 4),
    ('Smooth gameplay mechanics, very satisfying.', 17, '2024-09-20', '16:45:00', 24, 5),
    ('Impressive graphics and attention to detail.', 17, '2024-09-21', '19:15:00', 27, 4),
    ('A visually stunning game, great art style.', 17, '2024-09-22', '12:00:00', 29, 5),
    ('Great co-op experience, lots of fun with friends.', 17, '2024-09-23', '15:30:00', 40, 4),
    ('The narrative was emotional, left a lasting impression.', 17, '2024-09-24', '11:45:00', 41, 5),
    ('Enjoyed the storyline and character interactions.', 18, '2024-09-25', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 18, '2024-09-26', '10:00:00', 5, 4),
    ('Smooth gameplay mechanics, very satisfying.', 18, '2024-09-27', '16:45:00', 24, 5),
    ('Impressive graphics and attention to detail.', 18, '2024-09-28', '19:15:00', 27, 4),
    ('A visually stunning game, great art style.', 18, '2024-09-29', '12:00:00', 29, 5),
    ('Great co-op experience, lots of fun with friends.', 18, '2024-09-30', '15:30:00', 40, 4),
    ('The narrative was emotional, left a lasting impression.', 18, '2024-10-01', '11:45:00', 41, 5),
    ('Excellent combat mechanics, very satisfying.', 18, '2024-10-02', '17:00:00', 42, 4),
    ('Beautiful art style and music, very atmospheric.', 18, '2024-10-03', '14:00:00', 43, 5),
    ('Great game for strategy lovers, deep and engaging.', 18, '2024-10-04', '11:00:00', 44, 4),
    ('The graphics and art style were impressive.', 19, '2024-10-05', '14:30:00', 7, 5),
    ('The story kept me engaged from start to finish.', 19, '2024-10-06', '10:00:00', 10, 4),
    ('Enjoyed the exploration and discovery.', 19, '2024-10-07', '16:45:00', 12, 5),
    ('The gameplay mechanics were smooth and enjoyable.', 20, '2024-10-08', '14:30:00', 8, 5),
    ('The story was gripping, kept me hooked till the end.', 20, '2024-10-09', '10:00:00', 11, 4),
    ('Loved the open-world exploration and freedom.', 20, '2024-10-10', '16:45:00', 13, 5),
    ('Smooth combat mechanics, very satisfying.', 20, '2024-10-11', '19:15:00', 20, 4),
    ('A visually stunning game, great art style.', 20, '2024-10-12', '12:00:00', 26, 5),
    ('Great multiplayer experience, lots of fun with friends.', 20, '2024-10-13', '15:30:00', 35, 4),
	('Great storyline and character development.', 21, '2024-10-14', '14:30:00', 1, 4),
    ('The graphics were impressive, very detailed.', 21, '2024-10-15', '10:00:00', 3, 5),
    ('Enjoyed the open-world exploration.', 21, '2024-10-16', '16:45:00', 6, 4),
    ('Smooth combat mechanics, very satisfying.', 21, '2024-10-17', '19:15:00', 9, 5),
    ('Addictive gameplay loop, kept me hooked.', 21, '2024-10-18', '12:00:00', 15, 4),
    ('Great co-op experience, lots of fun with friends.', 21, '2024-10-19', '15:30:00', 19, 5),
    ('The narrative was emotional, left a lasting impression.', 21, '2024-10-20', '11:45:00', 22, 4),
    ('Excellent combat mechanics, very satisfying.', 21, '2024-10-21', '17:00:00', 24, 5),
    ('Loved the story and character development.', 22, '2024-10-22', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 22, '2024-10-23', '10:00:00', 5, 4),
    ('Smooth gameplay mechanics, very satisfying.', 22, '2024-10-24', '16:45:00', 10, 5),
    ('Impressive graphics and attention to detail.', 22, '2024-10-25', '19:15:00', 13, 4),
    ('The graphics and art style were impressive.', 23, '2024-10-26', '14:30:00', 7, 5),
    ('The story kept me engaged from start to finish.', 23, '2024-10-27', '10:00:00', 11, 4),
    ('Enjoyed the storyline and character interactions.', 24, '2024-10-28', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 24, '2024-10-29', '10:00:00', 5, 4),
    ('Smooth gameplay mechanics, very satisfying.', 24, '2024-10-30', '16:45:00', 24, 5),
    ('Impressive graphics and attention to detail.', 24, '2024-10-31', '19:15:00', 27, 4),
    ('A visually stunning game, great art style.', 24, '2024-11-01', '12:00:00', 29, 5),
    ('Great co-op experience, lots of fun with friends.', 24, '2024-11-02', '15:30:00', 40, 4),
    ('The narrative was emotional, left a lasting impression.', 24, '2024-11-03', '11:45:00', 41, 5),
    ('Excellent combat mechanics, very satisfying.', 24, '2024-11-04', '17:00:00', 42, 4),
    ('Beautiful art style and music, very atmospheric.', 24, '2024-11-05', '14:00:00', 43, 5),
    ('The gameplay mechanics were smooth and enjoyable.', 25, '2024-11-06', '14:30:00', 8, 5),
    ('The story was gripping, kept me hooked till the end.', 25, '2024-11-07', '10:00:00', 11, 4),
    ('Loved the open-world exploration and freedom.', 25, '2024-11-08', '16:45:00', 13, 5),
    ('Smooth combat mechanics, very satisfying.', 25, '2024-11-09', '19:15:00', 20, 4),
    ('A visually stunning game, great art style.', 25, '2024-11-10', '12:00:00', 26, 5),
    ('Great multiplayer experience, lots of fun with friends.', 25, '2024-11-11', '15:30:00', 35, 4),
    ('The narrative was emotional, left a lasting impression.', 25, '2024-11-12', '11:45:00', 37, 5),
    ('Excellent combat mechanics, very satisfying.', 25, '2024-11-13', '17:00:00', 39, 4),
    ('Beautiful art style and music, very atmospheric.', 25, '2024-11-14', '14:00:00', 44, 5),
    ('Great game for strategy lovers, deep and engaging.', 25, '2024-11-15', '11:00:00', 45, 4),
	('Loved the storyline and character development.', 26, '2024-11-16', '14:30:00', 1, 4),
    ('The graphics were impressive, very detailed.', 26, '2024-11-17', '10:00:00', 3, 5),
    ('Enjoyed the open-world exploration.', 26, '2024-11-18', '16:45:00', 6, 4),
    ('Smooth combat mechanics, very satisfying.', 26, '2024-11-19', '19:15:00', 9, 5),
    ('Addictive gameplay loop, kept me hooked.', 26, '2024-11-20', '12:00:00', 15, 4),
    ('Great co-op experience, lots of fun with friends.', 26, '2024-11-21', '15:30:00', 19, 5),
    ('The narrative was emotional, left a lasting impression.', 27, '2024-11-22', '11:45:00', 41, 5),
    ('Excellent combat mechanics, very satisfying.', 27, '2024-11-23', '17:00:00', 42, 4),
    ('Beautiful art style and music, very atmospheric.', 27, '2024-11-24', '14:00:00', 43, 5),
    ('Great game for strategy lovers, deep and engaging.', 27, '2024-11-25', '11:00:00', 44, 4),
    ('Interesting storyline and characters.', 27, '2024-11-26', '19:30:00', 48, 5),
    ('Smooth gameplay mechanics, very satisfying.', 27, '2024-11-27', '16:45:00', 49, 4),
    ('Impressive graphics and attention to detail.', 27, '2024-11-28', '19:15:00', 46, 5),
    ('Enjoyed the storyline and character interactions.', 28, '2024-11-29', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 28, '2024-11-30', '10:00:00', 5, 4),
    ('Smooth gameplay mechanics, very satisfying.', 28, '2024-12-01', '16:45:00', 24, 5),
    ('Impressive graphics and attention to detail.', 29, '2024-12-02', '19:15:00', 27, 4),
    ('A visually stunning game, great art style.', 29, '2024-12-03', '12:00:00', 29, 5),
    ('Great co-op experience, lots of fun with friends.', 29, '2024-12-04', '15:30:00', 40, 4),
    ('The narrative was emotional, left a lasting impression.', 29, '2024-12-05', '11:45:00', 41, 5),
    ('Excellent combat mechanics, very satisfying.', 30, '2024-12-06', '17:00:00', 42, 4),
    ('Beautiful art style and music, very atmospheric.', 30, '2024-12-07', '14:00:00', 43, 5),
    ('Great game for strategy lovers, deep and engaging.', 30, '2024-12-08', '11:00:00', 44, 4),
    ('Interesting storyline and characters.', 30, '2024-12-09', '19:30:00', 48, 5),
    ('Smooth gameplay mechanics, very satisfying.', 30, '2024-12-10', '16:45:00', 49, 4),
    ('Impressive graphics and attention to detail.', 30, '2024-12-11', '19:15:00', 35, 5),
    ('Loved the story and character development.', 30, '2024-12-12', '14:30:00', 2, 5),
    ('The world-building was fantastic, very immersive.', 30, '2024-12-13', '10:00:00', 5, 4);


SELECT * FROM GameVault_Review;

INSERT INTO GameVault_Post (Texto,Utilizador_ID,Data_post,Hora,Titulo) VALUES
	('Exploring the vast world of Skyrim has been an amazing adventure!', 31, '2024-12-16', '14:30:00', 'Skyrim Adventure'),
    ('Just finished an intense session in DOOM Eternal. Rip and tear!', 31, '2024-12-17', '10:00:00', 'DOOM Eternal - Rip and Tear!'),
    ('Enjoying the strategic depth of Fire Emblem: Three Houses.', 31, '2024-12-18', '16:45:00', 'Fire Emblem Strategy'),
    ('Hollow Knight has such a beautiful art style and challenging gameplay.', 31, '2024-12-19', '19:15:00', 'Hollow Knight - Art and Challenge'),
    ('Marvel''s Spider-Man swings into action with incredible gameplay mechanics.', 31, '2024-12-20', '12:00:00', 'Spider-Man Gameplay'),
    ('Just started my journey in Genshin Impact. Excited to explore Teyvat!', 31, '2024-12-21', '15:30:00', 'Genshin Impact - Journey Begins'),
    ('Stardew Valley is a relaxing escape into the world of farming and community.', 31, '2024-12-22', '11:45:00', 'Stardew Valley - Relaxing Farm Life'),
    ('Diving deep into the mysteries of Control. The atmosphere is intense!', 31, '2024-12-23', '17:00:00', 'Control - Atmospheric Mystery'),
	('Just finished playing Red Dead Redemption 2. The story blew me away!', 32, '2024-12-16', '14:30:00', 'Red Dead Redemption 2 - Incredible Story'),
    ('Exploring the world of The Witcher 3: Wild Hunt. So much to discover!', 32, '2024-12-17', '10:00:00', 'The Witcher 3 - World Exploration'),
    ('Cyberpunk 2077 has some of the most immersive futuristic cityscapes.', 32, '2024-12-18', '16:45:00', 'Cyberpunk 2077 - Futuristic Immersion'),
    ('Grand Theft Auto V - Still enjoying the chaos and freedom of Los Santos.', 32, '2024-12-19', '19:15:00', 'GTA V - Chaos and Freedom'),
    ('Marvel''s Spider-Man - Swinging through New York is so exhilarating!', 32, '2024-12-20', '12:00:00', 'Spider-Man - Exhilarating Swings'),
    ('Minecraft - Building and exploring endless possibilities in blocky worlds.', 32, '2024-12-21', '15:30:00', 'Minecraft - Endless Exploration'),
    ('Fortnite - Battle Royale action never gets old with friends.', 32, '2024-12-22', '11:45:00', 'Fortnite - Battle Royale Fun'),
    ('Among Us - Mastering the art of deception in this social deduction game.', 32, '2024-12-23', '17:00:00', 'Among Us - Deception Mastery'),
    ('Diving into the dark world of Bloodborne. The challenge is intense!', 33, '2024-12-16', '14:30:00', 'Bloodborne - Intense Challenge'),
    ('Sekiro: Shadows Die Twice - Mastering the swordplay and stealth tactics.', 33, '2024-12-17', '10:00:00', 'Sekiro - Mastering Swordplay'),
    ('Ghost of Tsushima - Embracing the samurai way in feudal Japan.', 33, '2024-12-18', '16:45:00', 'Ghost of Tsushima - Samurai Journey'),
    ('Resident Evil Village - Heart-pounding horror and suspense at every corner.', 33, '2024-12-19', '19:15:00', 'Resident Evil Village - Heart-Pounding Horror'),
    ('Hades - Descending into the depths of the underworld has never been more fun.', 33, '2024-12-20', '12:00:00', 'Hades - Descending to the Underworld'),
    ('Death Stranding - A hauntingly beautiful journey through a post-apocalyptic world.', 33, '2024-12-21', '15:30:00', 'Death Stranding - Haunting Journey'),
    ('Persona 5 - Unraveling the mysteries of the metaverse and changing hearts.', 33, '2024-12-22', '11:45:00', 'Persona 5 - Unraveling Mysteries'),
    ('DOOM Eternal - Ripping and tearing through demon hordes with brutal efficiency.', 33, '2024-12-23', '17:00:00', 'DOOM Eternal - Brutal Efficiency'),
	('Just completed Ori and the Will of the Wisps. The art and music are breathtaking!', 34, '2024-12-16', '14:30:00', 'Ori and the Will of the Wisps - Breathtaking Experience'),
    ('Cuphead - Challenging boss battles with stunning 1930s cartoon aesthetics.', 34, '2024-12-17', '10:00:00', 'Cuphead - Stunning Aesthetics'),
    ('Dishonored 2 - Stealth and supernatural powers make for thrilling gameplay.', 34, '2024-12-18', '16:45:00', 'Dishonored 2 - Thrilling Gameplay'),
    ('Metal Gear Solid V: The Phantom Pain - Infiltrating and outsmarting enemies.', 34, '2024-12-19', '19:15:00', 'Metal Gear Solid V - Infiltration Tactics'),
    ('Divinity: Original Sin II - Crafting unique strategies with deep RPG mechanics.', 34, '2024-12-20', '12:00:00', 'Divinity: Original Sin II - RPG Mechanics'),
    ('Bayonetta 2 - Stylish action and epic boss fights.', 34, '2024-12-21', '15:30:00', 'Bayonetta 2 - Stylish Action'),
    ('Hollow Knight - Unraveling the mysteries of Hallownest.', 34, '2024-12-22', '11:45:00', 'Hollow Knight - Hallownest Mysteries'),
    ('Tetris Effect - Mesmerizing visuals and addictive gameplay.', 34, '2024-12-23', '17:00:00', 'Tetris Effect - Mesmerizing Gameplay'),
	('Persona 4 Golden - Reliving the adventures in Inaba.', 35, '2024-12-16', '14:30:00', 'Persona 4 Golden - Adventures in Inaba'),
    ('Dragon Quest XI: Echoes of an Elusive Age - Epic journey across Erdrea.', 35, '2024-12-17', '10:00:00', 'Dragon Quest XI - Epic Journey'),
    ('Xenoblade Chronicles 2 - Exploring the vast Titans of Alrest.', 35, '2024-12-18', '16:45:00', 'Xenoblade Chronicles 2 - Exploring Alrest'),
    ('Fire Emblem: Three Houses - Leading the Black Eagles to victory.', 35, '2024-12-19', '19:15:00', 'Fire Emblem - Leading the Black Eagles'),
    ('The Outer Worlds - Decisions that shape the fate of Halcyon.', 35, '2024-12-20', '12:00:00', 'The Outer Worlds - Shaping Halcyon'),
    ('Apex Legends - Mastering the legends and conquering the arena.', 35, '2024-12-21', '15:30:00', 'Apex Legends - Conquering the Arena'),
    ('Doom (2016) - Fighting demons with adrenaline-pumping action.', 35, '2024-12-22', '11:45:00', 'Doom (2016) - Adrenaline Action'),
    ('GameVault - Excited to share my gaming experiences with everyone!', 35, '2024-12-23', '17:00:00', 'GameVault - Sharing Experiences'),
	('Skyrim - A journey through the land of the Nords.', 36, '2024-12-16', '14:30:00', 'Skyrim - Journey through Skyrim'),
    ('DOOM Eternal - Ripping and tearing through demon hordes with brutality.', 36, '2024-12-17', '10:00:00', 'DOOM Eternal - Ripping and Tearing'),
    ('Fire Emblem: Three Houses - Tactical battles and strategic choices.', 36, '2024-12-18', '16:45:00', 'Fire Emblem - Tactical Battles'),
    ('The Outer Worlds - A space adventure with moral dilemmas.', 36, '2024-12-19', '19:15:00', 'The Outer Worlds - Space Adventure'),
    ('Apex Legends - Competing to become the Apex Champion.', 36, '2024-12-20', '12:00:00', 'Apex Legends - Apex Champion'),
    ('Doom (2016) - Relentless action against the forces of Hell.', 36, '2024-12-21', '15:30:00', 'Doom (2016) - Relentless Action'),
    ('GameVault - Sharing my passion for gaming with the community!', 36, '2024-12-22', '11:45:00', 'GameVault - Passion for Gaming'),
    ('Tetris Effect - Immersed in the mesmerizing world of Tetris.', 36, '2024-12-23', '17:00:00', 'Tetris Effect - Mesmerizing World');

SELECT * FROM GameVault_Post;

INSERT INTO GameVault_Resposta (Texto,Utilizador_ID,Data_reposta,Hora,Post_ID) VALUES
	('Skyrim is indeed a masterpiece! Have you explored the Dawnguard DLC?', 37, '2024-12-16', '15:00:00', 1),
    ('DOOM Eternal is pure adrenaline! Which demon gave you the toughest fight?', 37, '2024-12-17', '10:30:00', 2),
    ('Fire Emblem: Three Houses is all about those critical decisions. Who''s your favorite house leader?', 37, '2024-12-18', '17:00:00', 3),
    ('Hollow Knight''s art style is stunning! Which boss gave you the most trouble?', 37, '2024-12-19', '19:30:00', 4),
    ('Spider-Man''s web-swinging mechanics are so fluid! Which suit do you use the most?', 37, '2024-12-20', '12:30:00', 5),
    ('Genshin Impact has such a vast world! Which element do you prefer using in battles?', 37, '2024-12-21', '16:00:00', 6),
    ('Stardew Valley is so relaxing! Which crop do you find the most profitable?', 37, '2024-12-22', '12:15:00', 7),
    ('Control''s atmosphere is eerie! Which area of the Oldest House intrigues you the most?', 37, '2024-12-23', '17:30:00', 8),
	('Red Dead Redemption 2 has such a gripping story! Which character impacted you the most?', 38, '2024-12-16', '15:00:00', 9),
    ('The Witcher 3''s world is vast indeed! Have you encountered any interesting monsters lately?', 38, '2024-12-17', '10:30:00', 10),
    ('Cyberpunk 2077''s cityscapes are breathtaking! What''s your favorite district in Night City?', 38, '2024-12-18', '17:00:00', 11),
    ('GTA V''s chaos is unmatched! Any memorable moments from your latest rampage?', 38, '2024-12-19', '19:30:00', 12),
    ('Spider-Man''s swinging feels so freeing! Which villain encounter was the most thrilling for you?', 38, '2024-12-20', '12:30:00', 13),
    ('Minecraft''s creativity knows no bounds! What''s the most impressive structure you''ve built?', 38, '2024-12-21', '16:00:00', 14),
    ('Fortnite''s battles are intense! Which weapon loadout do you prefer?', 38, '2024-12-22', '12:15:00', 15),
    ('Among Us'' social dynamics are fascinating! What''s your strategy as an imposter?', 38, '2024-12-23', '17:30:00', 16),
    ('Bloodborne''s challenge is legendary! Which boss battle tested your skills the most?', 39, '2024-12-16', '15:00:00', 17),
    ('Sekiro''s combat demands precision! How did you overcome your first major boss?', 39, '2024-12-17', '10:30:00', 18),
    ('Ghost of Tsushima captures the samurai spirit! Have you mastered any special techniques?', 39, '2024-12-18', '17:00:00', 19),
    ('Resident Evil Village''s horror is spine-chilling! Which encounter made you jump the most?', 39, '2024-12-19', '19:30:00', 20),
    ('Hades'' underworld is full of surprises! Which weapon upgrade path do you prefer?', 39, '2024-12-20', '12:30:00', 21),
    ('Death Stranding''s world is hauntingly beautiful! What''s the most challenging delivery you''ve made?', 39, '2024-12-21', '16:00:00', 22),
    ('Persona 5''s story is intriguing! Which palace ruler was the most memorable for you?', 39, '2024-12-22', '12:15:00', 23),
    ('DOOM Eternal''s action is relentless! How do you handle the Slayer Gates?', 39, '2024-12-23', '17:30:00', 24),
    ('Ori and the Will of the Wisps'' art and music are truly breathtaking! Any favorite moment from the story?', 40, '2024-12-16', '15:00:00', 25),
    ('Cuphead''s boss battles are so challenging yet rewarding! Which boss took the most attempts?', 40, '2024-12-17', '10:30:00', 26),
    ('Dishonored 2''s stealth mechanics add so much depth! Have you tried a high chaos playthrough?', 40, '2024-12-18', '17:00:00', 27),
    ('Metal Gear Solid V''s infiltration is thrilling! Any favorite tactic for taking down enemies?', 40, '2024-12-19', '19:30:00', 28),
    ('Divinity: Original Sin II''s RPG mechanics are deep indeed! Which companion do you prefer in your party?', 40, '2024-12-20', '12:30:00', 29),
    ('Bayonetta 2''s action sequences are stylish! Which climax battle left you awestruck?', 40, '2024-12-21', '16:00:00', 30),
    ('Hollow Knight''s mysteries are captivating! Which area of Hallownest do you find the most intriguing?', 40, '2024-12-22', '12:15:00', 31),
    ('Tetris Effect''s visuals are mesmerizing indeed! What''s your highest score in Journey mode?', 40, '2024-12-23', '17:30:00', 32),
    ('Persona 4 Golden''s adventures in Inaba are nostalgic! Any new discoveries in your latest playthrough?', 41, '2024-12-16', '15:00:00', 33),
    ('Dragon Quest XI''s journey across Erdrea is epic! Which town or city is your favorite so far?', 41, '2024-12-17', '10:30:00', 34),
    ('Xenoblade Chronicles 2''s Titans of Alrest are awe-inspiring! Which Titan has the most memorable scenery?', 41, '2024-12-18', '17:00:00', 35),
    ('Fire Emblem: Three Houses'' strategic battles are intense! Which route did you choose first?', 41, '2024-12-19', '19:30:00', 36),
    ('The Outer Worlds'' decisions shape Halcyon''s fate! Any unexpected consequences from your choices?', 41, '2024-12-20', '12:30:00', 37),
    ('Apex Legends'' arena battles are competitive! Which legend suits your playstyle the best?', 41, '2024-12-21', '16:00:00', 38),
    ('Doom (2016)''s demon fights are adrenaline-pumping! Which demon type do you find the most challenging?', 41, '2024-12-22', '12:15:00', 39),
    ('Excited to share my gaming experiences with everyone in the GameVault community!', 41, '2024-12-23', '17:30:00', 40),
    ('Skyrim''s exploration is endless! Have you found any hidden treasures or easter eggs?', 42, '2024-12-16', '15:00:00', 41),
    ('DOOM Eternal''s demon hordes keep you on your toes! Which demon type do you find the most challenging?', 42, '2024-12-17', '10:30:00', 42),
	('Spider-Man''s swinging feels so freeing! Which villain encounter was the most thrilling for you?', 43, '2024-12-20', '12:30:00', 13),
    ('How do you approach combat challenges in Spider-Man''s DLCs?', 43, '2024-12-20', '13:00:00', 13),
    ('Which Spider-Man suit power do you find the most useful in different situations?', 43, '2024-12-20', '13:30:00', 13),
    ('Minecraft''s creativity knows no bounds! What''s the most impressive structure you''ve built?', 43, '2024-12-21', '16:00:00', 14),
    ('Do you prefer building in Creative mode or surviving in Survival mode in Minecraft?', 43, '2024-12-21', '16:30:00', 14),
    ('Have you tried any Minecraft mods that enhanced your gameplay experience?', 43, '2024-12-21', '17:00:00', 14),
    ('Fortnite''s battles are intense! Which weapon loadout do you prefer?', 43, '2024-12-22', '12:15:00', 15),
    ('What''s your strategy for building defenses quickly in Fortnite?', 43, '2024-12-22', '12:45:00', 15),
    ('Have you won any Victory Royales in Fortnite''s competitive modes?', 43, '2024-12-22', '13:15:00', 15),
    ('Among Us'' social dynamics are fascinating! What''s your strategy as an imposter?', 43, '2024-12-23', '17:30:00', 16),
    ('Which Among Us map do you enjoy playing on the most?', 43, '2024-12-23', '18:00:00', 16),
    ('Have you successfully pulled off any big brain plays in Among Us?', 43, '2024-12-23', '18:30:00', 16),
	('How do you deal with the Marauder enemies in DOOM Eternal?', 44, '2024-12-17', '11:30:00', 2),
    ('Fire Emblem: Three Houses is all about those critical decisions. Who''s your favorite house leader?', 44, '2024-12-18', '17:00:00', 3),
    ('Have you completed all the side quests in Fire Emblem: Three Houses?', 44, '2024-12-18', '17:30:00', 3),
    ('Which character support pairing in Fire Emblem: Three Houses surprised you the most?', 44, '2024-12-18', '18:00:00', 3),
    ('Hollow Knight''s art style is stunning! Which boss gave you the most trouble?', 44, '2024-12-19', '19:30:00', 4),
    ('What charms did you find most useful in Hollow Knight?', 44, '2024-12-19', '20:00:00', 4),
    ('Have you discovered all the hidden areas in Hollow Knight?', 44, '2024-12-19', '20:30:00', 4),
    ('Spider-Man''s web-swinging mechanics are so fluid! Which suit do you use the most?', 44, '2024-12-20', '12:30:00', 5),
    ('Which iconic Spider-Man villain would you like to see in the next game?', 44, '2024-12-20', '13:00:00', 5),
    ('Do you prefer the story missions or side activities in Spider-Man?', 44, '2024-12-20', '13:30:00', 5),
    ('Genshin Impact has such a vast world! Which element do you prefer using in battles?', 44, '2024-12-21', '16:00:00', 6),
    ('What''s your strategy for tackling the Spiral Abyss challenges in Genshin Impact?', 44, '2024-12-21', '16:30:00', 6),
    ('Have you obtained any 5-star characters in Genshin Impact?', 44, '2024-12-21', '17:00:00', 6),
    ('Stardew Valley is so relaxing! Which crop do you find the most profitable?', 44, '2024-12-22', '12:15:00', 7),
    ('Do you focus more on farming, mining, or fishing in Stardew Valley?', 44, '2024-12-22', '12:45:00', 7),
	('Which Shinobi Prosthetic tool did you find the most useful in Sekiro?', 45, '2024-12-17', '11:00:00', 18),
    ('Have you discovered all the different endings in Sekiro: Shadows Die Twice?', 45, '2024-12-17', '11:30:00', 18),
    ('Ghost of Tsushima''s open world is stunning! Which region of Tsushima do you find the most beautiful?', 45, '2024-12-18', '17:00:00', 19),
    ('How do you balance Jin''s samurai honor with the Ghost''s stealth tactics in Ghost of Tsushima?', 45, '2024-12-18', '17:30:00', 19),
    ('Which duel against a Mongol leader in Ghost of Tsushima was the most memorable for you?', 45, '2024-12-18', '18:00:00', 19),
    ('Resident Evil Village''s horror atmosphere is chilling! Which monster encounter scared you the most?', 45, '2024-12-19', '19:30:00', 20),
    ('What''s your strategy for managing resources in Resident Evil Village?', 45, '2024-12-19', '20:00:00', 20),
    ('Have you explored all the secrets hidden in Castle Dimitrescu in Resident Evil Village?', 45, '2024-12-19', '20:30:00', 20),
    ('Hades'' gameplay is addictive! Which weapon from the Olympian gods is your favorite?', 45, '2024-12-20', '12:30:00', 21),
    ('How do you strategize your escape attempts from the Underworld in Hades?', 45, '2024-12-20', '13:00:00', 21),
    ('Which god''s blessings do you prioritize in Hades for your builds?', 45, '2024-12-20', '13:30:00', 21),
    ('Death Stranding''s world is hauntingly beautiful! How do you navigate the hazardous terrain?', 45, '2024-12-21', '16:00:00', 22),
    ('What''s your favorite equipment or vehicle in Death Stranding?', 45, '2024-12-21', '16:30:00', 22);

SELECT * FROM GameVault_Resposta;

INSERT INTO GameVault_Empresa (Nome,Ano_criacao,Localizacao) VALUES
	('CD Projekt Red', 1994, 'Warsaw, Poland'),
    ('Rockstar Games', 1998, 'New York City, USA'),
    ('Nintendo', 1889, 'Kyoto, Japan'),
    ('Epic Games', 1991, 'Cary, North Carolina, USA'),
    ('Mojang Studios', 2009, 'Stockholm, Sweden'),
    ('Santa Monica Studio', 1999, 'Los Angeles, California, USA'),
    ('InnerSloth', 2015, 'Redmond, Washington, USA');

SELECT * FROM GameVault_Empresa;

INSERT INTO GameVault_Editora (Empresa_ID) VALUES
	(1),
	(2),
	(3),
	(5);

SELECT * FROM GameVault_Editora;

INSERT INTO GameVault_Desenvolvedora (Empresa_ID) VALUES
	(4),
	(6),
	(7);

SELECT * FROM GameVault_Desenvolvedora;

INSERT INTO GameVault_Plataforma (Nome) VALUES
	('PlayStation'),
    ('Xbox'),
    ('Nintendo Switch'),
    ('PC'),
    ('Mobile');

SELECT * FROM GameVault_Plataforma;

INSERT INTO GameVault_DLC (Nome,Jogo_ID,Tipo,Data_lancamento) VALUES
    ('Hearts of Stone', 1, 'Expansion', '2015-10-13'),
    ('Blood and Wine', 1, 'Expansion', '2016-05-31'),
    ('Hearts of Stone', 1, 'Expansion', '2015-10-13'),
    ('Blood and Wine', 1, 'Expansion', '2016-05-31'),
    ('Red Dead Online', 2, 'Online', '2018-11-27'),
    ('Expansion 1: TBD', 4, 'Expansion', '2018-11-27'),
    ('GTA Online: The Cayo Perico Heist', 5, 'Online', '2020-12-15'),
    ('Caves & Cliffs Update: Part I', 7, 'Update', '2021-06-08'),
    ('Caves & Cliffs Update: Part II', 7, 'Update', '2021-11-30'),
    ('Chapter 3: Season 1 - Flipped', 8, 'Season', '2022-03-20'),
    ('Overwatch 2: PvP Update', 12, 'Expansion', '2023-06-15'),
    ('Wrath of the Druids', 15, 'Expansion', '2021-05-13'),
    ('The Siege of Paris', 15, 'Expansion', '2021-08-12'),
    ('The Ancient Gods - Part One', 18, 'Expansion', '2020-10-20'),
    ('The Ancient Gods - Part Two', 18, 'Expansion', '2021-03-18'),
    ('Happy Home Paradise', 19, 'Expansion', '2021-11-05'),
    ('Stardew Valley 1.5 Update', 21, 'Update', '2020-12-21'),
    ('Legends', 23, 'Expansion', '2020-10-16'),
    ('Resident Evil Re:Verse', 24, 'Expansion', '2021-07-08'),
    ('Version 2.4: Horizon of Dreams', 27, 'Update', '2023-02-08'),
    ('Iceborne', 29, 'Expansion', '2019-09-06'),
    ('AWE', 31, 'Expansion', '2020-08-27'),
    ('The Spirit Trials Update', 32, 'Update', '2021-05-10'),
    ('Season 11: Escape', 37, 'Season', '2023-02-07'),
    ('Unto the Evil', 38, 'Expansion', '2016-08-04'),
    ('Hell Followed', 38, 'Expansion', '2016-10-27'),
    ('Bloodfall', 38, 'Expansion', '2016-12-15');



SELECT * FROM GameVault_DLC;

INSERT INTO GameVault_Genero (Nome) VALUES
	('Action'),
    ('Adventure'),
    ('Role-Playing'),
    ('Strategy'),
    ('Simulation'),
    ('Sports'),
    ('Puzzle'),
    ('Racing'),
    ('Fighting');

SELECT * FROM GameVault_Genero;

INSERT INTO GameVault_Loja (Nome) VALUES
	('Steam'),
    ('PlayStation Store'),
    ('Xbox Store'),
    ('Nintendo eShop'),
    ('Epic Games Store'),
    ('GOG.com'),
    ('Origin'),
    ('Ubisoft Store');

SELECT * FROM GameVault_Loja;

INSERT INTO GameVault_Publica (Editora_ID,Jogo_ID) VALUES
	(1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (5, 6),
    (1, 7),
    (1, 8),
    (2, 9),
    (2, 10),
    (3, 11),
    (3, 12),
    (5, 13),
    (5, 14),
    (5, 15),
	(1, 16),
    (1, 17),
    (2, 18),
    (2, 19),
    (3, 20),
    (5, 21),
    (1, 22),
    (1, 23),
    (2, 24),
    (2, 25),
    (3, 26),
    (3, 27),
    (5, 28),
    (5, 29),
    (5, 30),
	(2, 31),
    (2, 32),
    (3, 33),
    (3, 34),
    (5, 35),
    (5, 36),
    (5, 37),
	(1, 38),
    (1, 39),
    (2, 40),
    (2, 41),
    (3, 42),
    (5, 43),
    (1, 44),
    (1, 45),
    (2, 46),
    (2, 47),
    (3, 48),
    (3, 49);


SELECT * FROM GameVault_Publica;

INSERT INTO GameVault_Desenvolve (Desenvolvedora_ID,Jogo_ID) VALUES
	(4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5),
    (4, 6),
    (4, 7),
    (4, 8),
    (4, 9),
    (4, 10),
    (4, 11),
    (6, 12),
    (6, 13),
    (6, 14),
    (6, 15),
	(6, 16),
    (6, 17),
    (6, 18),
    (6, 19),
    (6, 20),
    (6, 21),
    (7, 22),
    (7, 23),
    (7, 24),
    (7, 25),
    (7, 26),
    (7, 27),
    (7, 28),
    (7, 29),
    (7, 30),
	(7, 31),
    (7, 32),
    (4, 33),
    (4, 34),
    (4, 35),
    (6, 36),
    (6, 37),
	(6, 38),
    (6, 39),
    (6, 40),
    (7, 41),
    (7, 42),
    (7, 43),
    (7, 44),
    (7, 45),
    (7, 46),
    (7, 47),
    (7, 48),
    (7, 49);

SELECT * FROM GameVault_Desenvolve;

INSERT INTO GameVault_Vende (Loja_ID,Jogo_ID,Preco) VALUES
    (1, 1, 29.99),
    (2, 2, 20.52),
    (3, 3, 10.75),
    (4, 4, 38.21),
    (5, 5, 45.63),
    (6, 6, 15.84),
    (7, 7, 9.37),
    (8, 8, 22.09),
    (1, 9, 7.62),
    (2, 10, 31.48),
    (3, 11, 19.25),
    (4, 12, 12.56),
    (5, 13, 27.39),
    (6, 14, 40.17),
    (7, 15, 18.93),
    (8, 16, 5.67),
    (1, 17, 37.84),
    (2, 18, 14.29),
    (3, 19, 25.91),
    (4, 20, 8.73),
    (5, 21, 42.15),
    (6, 22, 30.68),
    (7, 23, 11.82),
    (8, 24, 16.50),
    (1, 25, 33.27),
    (2, 26, 6.84),
    (3, 27, 23.76),
    (4, 28, 17.91),
    (5, 29, 9.99),
    (6, 30, 28.14),
    (7, 31, 41.25),
    (8, 32, 19.08),
    (1, 33, 13.50),
    (2, 34, 24.93),
    (3, 35, 38.62),
    (4, 36, 11.07),
    (5, 37, 32.75),
    (6, 38, 8.19),
    (7, 39, 44.36),
    (8, 40, 21.45),
    (1, 41, 15.88),
    (2, 42, 36.74),
    (3, 43, 27.01),
    (4, 44, 19.76),
    (5, 45, 5.88),
    (6, 46, 31.93),
    (7, 47, 12.60),
    (8, 48, 25.37),
    (1, 49, 40.59);

SELECT * FROM GameVault_Vende;

INSERT INTO GameVault_Jogo_Genero (Genero_ID,Jogo_ID) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (1, 10),
    (2, 11),
    (3, 12),
    (4, 13),
    (5, 14),
    (6, 15),
    (7, 16),
    (8, 17),
    (9, 18),
    (1, 19),
    (2, 20),
    (3, 21),
    (4, 22),
    (5, 23),
    (6, 24),
    (7, 25),
    (8, 26),
    (9, 27),
    (1, 28),
    (2, 29),
    (3, 30),
    (4, 31),
    (5, 32),
    (6, 33),
    (7, 34),
    (8, 35),
    (9, 36),
    (1, 37),
    (2, 38),
    (3, 39),
    (4, 40),
    (5, 41),
    (6, 42),
    (7, 43),
    (8, 44),
    (9, 45),
    (1, 46),
    (2, 47),
    (3, 48),
    (4, 49);

SELECT * FROM GameVault_Jogo_Genero;

INSERT INTO GameVault_Disponibiliza (Plataforma_ID,Jogo_ID) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (1, 6),
    (2, 7),
    (3, 8),
    (4, 9),
    (5, 10),
    (1, 11),
    (2, 12),
    (3, 13),
    (4, 14),
    (5, 15),
    (1, 16),
    (2, 17),
    (3, 18),
    (4, 19),
    (5, 20),
    (1, 21),
    (2, 22),
    (3, 23),
    (4, 24),
    (5, 25),
    (1, 26),
    (2, 27),
    (3, 28),
    (4, 29),
    (5, 30),
    (1, 31),
    (2, 32),
    (3, 33),
    (4, 34),
    (5, 35),
    (1, 36),
    (2, 37),
    (3, 38),
    (4, 39),
    (5, 40),
    (1, 41),
    (2, 42),
    (3, 43),
    (4, 44),
    (5, 45),
    (1, 46),
    (2, 47),
    (3, 48),
    (4, 49);

SELECT * FROM GameVault_Disponibiliza;