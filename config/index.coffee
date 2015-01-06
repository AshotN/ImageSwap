module.exports =

	port: 5002
	mongo:
		url: 'mongodb://127.0.0.1:27017/imageswap'
		host: '127.0.0.1'
		port: 25
		sessionDb: 'imageswap-session'

	session:
		secret: 'w5989w74598gk0w84k5983wodioutrujizitrjgijhjgluilhtipuooiuwwgz'
		key: 'express.sid'
		db: 'mongodb://127.0.0.1:27017/imageswap-session'
		auto_reconnect: true

