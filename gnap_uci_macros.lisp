(include "gnap_token.lisp")

; Sequence Messages
; (1) CI -> AS = Request access to resource
(defmacro (CI_AS_1
        ci pk_ci
        rs rs_access
    )
    (cat "REQ" ci pk_ci rs rs_access (enc (cat ci pk_ci rs rs_access) (invk pk_ci))))

; (2) AS -> CI = Respond with eu_code and continue_access_token
(defmacro (AS_CI_2
        ci pk_ci
        as_cont_token_rand pk_as
        eu_code
        rs rs_access
    )
    (cat "RES" eu_code (CONT_ACCESS_TOKEN ci pk_ci as_cont_token_rand pk_as rs rs_access)))

; (3) CI -> EU = Send eu_code
(defmacro (CI_EU_3
        eu_code
    )
    (cat "DISPLAY" eu_code))

; (4, 5, 6, 8) EU <-> AS = Auth[NZ], user_code exchange
(defmacro (EU_AS_4_5_6_8
        as
        eu eu_code
    )
    (enc eu_code (ltk as eu)))

; (7) EU <-> AS = user_code success status
(defmacro (EU_AS_7
        as
        eu eu_code_status
    )
    (enc eu_code_status (ltk as eu)))

; (9) CI -> AS = continue_access_token (A)
; Ignore

; (10) AS -> CI = cont_access_token
; Ignore

; (11) CI -> AS = Continue Request (B)
(defmacro (CI_AS_11
        ci pk_ci
        as_cont_token_rand pk_as
        rs rs_access
    )
    (cat "REQ" (CONT_ACCESS_TOKEN ci pk_ci as_cont_token_rand pk_as rs rs_access) (enc (CONT_ACCESS_TOKEN ci pk_ci as_cont_token_rand pk_as rs rs_access) (invk pk_ci))))

; (12) AS -> CI = Grant Access
(defmacro (AS_CI_12
        ci pk_ci
        as_token_rand pk_as
        rs rs_access
    )
    (cat "RES" rs_access (ACCESS_TOKEN ci pk_ci as_token_rand pk_as rs rs_access)))

; (13) CI -> RS = Access API
(defmacro (CI_RS_13
        ci pk_ci
        as_token_rand pk_as
        rs rs_access
    )
    (cat "REQ" (ACCESS_TOKEN ci pk_ci as_token_rand pk_as rs rs_access) (enc (ACCESS_TOKEN ci pk_ci as_token_rand pk_as rs rs_access) (invk pk_ci))))

; (14) RS -> CI = API Response
(defmacro (RS_CI_14
        ci pk_ci
        as_token_rand pk_as
        rs rs_access rs_data
    )
    (cat "RES" rs_data (hash rs_data (ACCESS_TOKEN ci pk_ci as_token_rand pk_as rs rs_access))))
