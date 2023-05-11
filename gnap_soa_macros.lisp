(include "gnap_token.lisp")

; Sequence Messages
; (1) CI -> AS = Request access to resource
(defmacro (CI_AS_1
        ci ci_key
        rs rs_access
    )
    (cat "REQ" ci ci_key rs rs_access)
)

; (2) AS -> CI = Respond with access_token
(defmacro (AS_CI_2
        ci ci_key
        as_token_rand pk_as
        rs rs_access
    )
    (cat "RES" (ACCESS_TOKEN ci ci_key as_token_rand pk_as rs rs_access)))

; (3) CI -> RS = Access API
(defmacro (CI_RS_3
        ci ci_key
        as_token_rand pk_as
        rs rs_access
    )
    (cat "REQ" (ACCESS_TOKEN ci ci_key as_token_rand pk_as rs rs_access)))

; (4) RS -> CI = API Response
(defmacro (RS_CI_4
        ci ci_key
        as_token_rand pk_as
        rs rs_access rs_data
    )
    (cat "RES" rs_data (hash rs_data (ACCESS_TOKEN ci ci_key as_token_rand pk_as rs rs_access))))
