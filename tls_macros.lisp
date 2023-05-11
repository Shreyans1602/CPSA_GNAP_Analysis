(defmacro (ClientHello random)
    random)

(defmacro (ServerHello random)
    random)

(defmacro (Certificate server publickey ca)
    (cat server publickey (enc (hash server publickey) (privk ca))))

(defmacro (ClientKeyExchange pre_master_secret publickey)
    (enc pre_master_secret publickey))

(defmacro (MasterSecret pre_master_secret client_random server_random)
    (hash pre_master_secret client_random server_random))

(defmacro (ClientWriteKey master_secret)
    (hash master_secret "client write"))

(defmacro (ServerWriteKey master_secret)
    (hash master_secret "server write"))

(defmacro (ClientFinish client_random server_random pre_master_secret server publickey ca)
    (enc (hash pre_master_secret "client finished"
	       (hash (ClientHello client_random)
		     (ServerHello server_random)
		     (Certificate server publickey ca)
		     (ClientKeyExchange pre_master_secret publickey)))
	 (ClientWriteKey (MasterSecret pre_master_secret client_random server_random))))

(defmacro (ServerFinish client_random server_random pre_master_secret server publickey ca)
    (enc (hash pre_master_secret "server finished"
	       (hash (ClientHello client_random)
		     (ServerHello server_random)
		     (Certificate server publickey ca)
		     (ClientKeyExchange pre_master_secret publickey)
		     (ClientFinish client_random server_random pre_master_secret server publickey ca)))
	 (ServerWriteKey (MasterSecret pre_master_secret client_random server_random))))

(defmacro (TLSclient_nocerts client_random server_random pre_master_secret server publickey ca)
    (^
     (send (ClientHello client_random))
     (recv (ServerHello server_random))
     (recv (Certificate server publickey ca))
     (send (ClientKeyExchange pre_master_secret publickey))
     (send (ClientFinish client_random server_random pre_master_secret server publickey ca))
     (recv (ServerFinish client_random server_random pre_master_secret server publickey ca))))

(defmacro (TLSserver_nocertreq client_random server_random pre_master_secret server publickey ca)
    (^
     (recv (ClientHello client_random))
     (send (ServerHello server_random))
     (send (Certificate server publickey ca))
     (recv (ClientKeyExchange pre_master_secret publickey))
     (recv (ClientFinish client_random server_random pre_master_secret server publickey ca))
     (send (ServerFinish client_random server_random pre_master_secret server publickey ca))))

