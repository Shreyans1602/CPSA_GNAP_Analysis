; Tokens (Ex: JWK or similar signing mechanism)
; A token must be bound to a client instance's key
; pk_as = public_key of AS
; invk pk_as = private key of AS

; Continue Access Token
(defmacro (CONT_ACCESS_TOKEN ci ci_key as_cont_token_rand pk_as rs rs_access)
    (cat "CONT_ACCESS_TOKEN" ci ci_key as_cont_token_rand rs rs_access (enc "CONT_ACCESS_TOKEN" ci ci_key as_cont_token_rand rs rs_access (invk pk_as))))

; Access Token
(defmacro (ACCESS_TOKEN ci ci_key as_token_rand pk_as rs rs_access)
    (cat "ACCESS_TOKEN" ci ci_key as_token_rand rs rs_access (enc "ACCESS_TOKEN" ci ci_key as_token_rand rs rs_access (invk pk_as))))
