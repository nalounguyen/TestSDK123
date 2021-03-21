//
//  CCEnvironment.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

struct CCEnvironment {
    let type: CCEnvironmentType
    let apiKey: String
    
    init(config: CoreServiceConfiguration) {
        self.type = config.env
        self.apiKey = config.apiKey
    }
    
    
    var ENVIRONMENT_NAME: String {
        switch type {
        case .DEV:
            return "development"
        case .SIT:
            return "sit"
        case .UAT:
            return "uat"
        case .SANDBOX:
            return "sandbox"
        case .PRODUCTION:
            return "production"
        }
    }
    
    
    var WS_URL: String {
        switch type {
        case .DEV:
            return "wss://dev-api.credify.one/v1/ws"
        case .SIT:
            return "wss://sit-api.credify.one/v1/ws"
        case .UAT:
            return "wss://uat-api.credify.one/v1/ws"
        case .SANDBOX:
            return "wss://sandbox-api.credify.one/v1/ws"
        case .PRODUCTION:
            return "wss://api.credify.one/v1/ws"
        }
    }
    
    var REST_URL: String {
        switch type {
        case .DEV:
            return "https://dev-api.credify.one"
        case .SIT:
            return "https://sit-api.credify.one"
        case .UAT:
            return "https://uat-api.credify.one"
        case .SANDBOX:
            return "https://sandbox-api.credify.one"
        case .PRODUCTION:
            return "https://api.credify.one"
        }
    }
    
    var OIDC_URL: String {
        switch type {
        case .DEV:
            return "https://dev-oidc-core.credify.one"
        case .SIT:
            return "https://sit-oidc-core.credify.one"
        case .UAT:
            return "https://uat-oidc-core.credify.one"
        case .SANDBOX:
            return "https://sandbox-oidc-core.credify.one"
        case .PRODUCTION:
            return "https://oidc-core.credify.one"
        }
    }
    
    var EOS_NETWORK: String {
        switch type {
        case .DEV:
            return "https://dev-nodeos.credify.one"
        case .SIT:
            return "https://sit-nodeos.credify.one"
        case .UAT:
            return "https://stage-nodeos.credify.one"
        case .SANDBOX:
            return "https://stage-nodeos.credify.one"
        case .PRODUCTION:
            return "http://nodeos-testnet.prod.credify.one"
        }
    }
    
    var WEB_APP_URL: String {
        switch type {
        case .DEV:
            return "https://dev-app.credify.one"
        case .SIT:
            return "https://sit-app.credify.one"
        case .UAT:
            return "https://uat-app.credify.one"
        case .SANDBOX:
            return "https://sandbox-app.credify.one"
        case .PRODUCTION:
            return "https://app.credify.one"
        }
    }
    
    var LINKEDIN_CLIENT_ID: String {
        switch type {
        case .DEV:
            return "812oybflmtmdbi"
        case .SIT:
            return "86gyi414uzab1g"
        case .UAT:
            return "862zp56k0462up"
        case .SANDBOX:
            return "861ie461m750mv"
        case .PRODUCTION:
            return "817z6e9ikbkxsw"
        }
    }
    
    var LINKEDIN_CLIENT_SECRET: String {
        switch type {
        case .DEV:
            return "0JHLf1lJlerGbpxb"
        case .SIT:
            return "2S2eJsa20iPpG7AM"
        case .UAT:
            return "LGH6dczDX9cHKLid"
        case .SANDBOX:
            return "jLZMMHdI25WU3DMH"
        case .PRODUCTION:
            return "AtF1082vwQFgBWRl"
        }
    }
    
    var LINKEDIN_REDIRECT_URL: String {
        switch type {
        case .DEV:
            return "https://dev-app.credify.one/social/callback"
        case .SIT:
            return "https://stage-app.credify.one/social/callback"
        case .UAT:
            return  "https://stage-app.credify.one/social/callback"
        case .SANDBOX:
            return "https://stage-app.credify.one/social/callback"
        case .PRODUCTION:
            return "https://app.credify.one/social/callback"
        }
    }
    
    var LINE_CLIENT_ID: String {
        switch type {
        case .DEV:
            return "1654287987"
        case .SIT:
            return ""
        case .UAT:
            return ""
        case .SANDBOX:
            return ""
        case .PRODUCTION:
            return ""
        }
    }
    var ONFIDO_TOKEN: String {
        switch type {
        case .DEV:
            return "api_sandbox.QKnDjXAL6p2.DNl3C9JLr6nnSWAC2qboRnQ0Zh-WeZ4x"
        case .SIT:
            return "api_sandbox.QKnDjXAL6p2.DNl3C9JLr6nnSWAC2qboRnQ0Zh-WeZ4x"
        case .UAT:
            return "api_sandbox.6RG_X_Cv3zi.xzh_mXKL38nQJMga6UFni8gK0JYaiGbD"
        case .SANDBOX:
            return "api_sandbox.Wcwiy3NHyn0.wW2_d0qJzhuRAwOrqNqJxzrQzauC2-cV"
        case .PRODUCTION:
            return "api_live.x26vkyaRdW2.MLWlTG_pm94nSQYOKBQGHH7wwArs42Mv"
        }
    }
    
    var PRIVACY_POLICY: String {
        switch type {
        case .DEV:
            return "https://credify.one/privacy-policy"
        case .SIT:
            return "https://credify.one/privacy-policy"
        case .UAT:
            return "https://credify.one/privacy-policy"
        case .SANDBOX:
            return "https://credify.one/privacy-policy"
        case .PRODUCTION:
            return "https://credify.one/privacy-policy"
        }
    }
    
    var TERMS_OF_USE: String {
        switch type {
        case .DEV:
            return "https://credify.one/terms-of-use"
        case .SIT:
            return "https://credify.one/terms-of-use"
        case .UAT:
            return "https://credify.one/terms-of-use"
        case .SANDBOX:
            return "https://credify.one/terms-of-use"
        case .PRODUCTION:
            return "https://credify.one/terms-of-use"
        }
    }
    
    var APPSTORE_ID: String {
        switch type {
        case .DEV:
            return ""
        case .SIT:
            return ""
        case .UAT:
            return ""
        case .SANDBOX:
            return ""
        case .PRODUCTION:
            return ""
        }
    }
}
