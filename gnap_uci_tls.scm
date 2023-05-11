(herald "GNAP User-Code Interaction using TLS")

(include "gnap_uci_tls_macros.lisp")

(defprotocol gnap_uci_tls basic
    ; CI
    (defrole client_instance
        (vars
            (ca ci as rs name)
            (r_ci_as r_ci_rs r_as_ci r_rs_ci pms_ci_as pms_ci_rs text)
            (access cont_access_token access_token user_code rs_data data)
            (pk_ci pk_as pk_rs akey)
            (ch_eu chan)
        )

        (trace
            (ROLE_CI
                ca
                ci pk_ci r_ci_as r_ci_rs pms_ci_as pms_ci_rs access
                as pk_as r_as_ci cont_access_token access_token
                ch_eu user_code
                rs pk_rs r_rs_ci rs_data
            )
        )

        (uniq-orig r_ci_as r_ci_rs pms_ci_as pms_ci_rs access)
        (non-orig (invk pk_ci) (invk pk_as) (invk pk_rs) (privk ca))
        (auth ch_eu)
        (conf ch_eu)
    )

    ; AS
    (defrole authorization_server
        (vars
            (ca ci as eu name)
            (r_ci_as r_as_ci r_as_eu r_eu_as pms_ci_as pms_eu_as text)
            (access cont_access_token access_token user_code user_code_status data)
            (pk_ci pk_as akey)
        )

        (trace
            (ROLE_AS
                ca
                ci pk_ci r_ci_as pms_ci_as access
                as pk_as r_as_ci r_as_eu cont_access_token access_token
                eu r_eu_as pms_eu_as user_code user_code_status
            )
        )

        (uniq-orig r_as_ci r_as_eu cont_access_token access_token user_code user_code_status)
        (non-orig (invk pk_ci) (invk pk_as) (privk ca) (ltk eu as))
    )

    ; EU
    (defrole end_user
        (vars
            (ca as eu name)
            (r_as_eu r_eu_as pms_eu_as text)
            (user_code user_code_status data)
            (pk_as akey)
            (ch_eu chan)
        )

        (trace
            (ROLE_EU
                ca
                as pk_as r_as_eu
                eu r_eu_as pms_eu_as ch_eu user_code user_code_status
            )
        )

        (uniq-orig r_eu_as pms_eu_as)
        (non-orig (invk pk_as) (privk ca) (ltk eu as))
        (auth ch_eu)
        (conf ch_eu)
    )

    ; RS
    (defrole resource_server
        (vars
            (ca rs name)
            (r_ci_rs r_rs_ci pms_ci_rs text)
            (access_token rs_data data)
            (pk_ci pk_rs akey)
        )

        (trace
            (ROLE_RS
                ca
                pk_ci r_ci_rs pms_ci_rs access_token
                rs pk_rs r_rs_ci rs_data
            )
        )

        (uniq-orig r_rs_ci rs_data)
        (non-orig (invk pk_ci) (invk pk_rs) (privk ca))
    )
)

(defskeleton gnap_uci_tls
    (vars
        (r_as_ci r_rs_ci text)
        (cont_access_token access_token user_code rs_data data)
    )

    (defstrandmax client_instance
        (r_as_ci r_as_ci) (r_rs_ci r_rs_ci)
        (cont_access_token cont_access_token) (access_token access_token) (user_code user_code) (rs_data rs_data)
    )

    (uniq-orig r_as_ci r_rs_ci cont_access_token access_token user_code rs_data)
)