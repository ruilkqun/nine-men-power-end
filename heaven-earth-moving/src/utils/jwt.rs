use serde::{ Deserialize, Serialize };
use chrono::prelude::*;
use jsonwebtoken::errors::ErrorKind;
use jsonwebtoken::{decode, encode, Algorithm, DecodingKey, EncodingKey, Header, Validation, TokenData};


#[derive(Debug, PartialEq,Serialize, Deserialize)]
struct Claims {
    #[serde(with = "jwt_numeric_date")]
    iat: DateTime<Utc>,
    #[serde(with = "jwt_numeric_date")]
    exp: DateTime<Utc>,
    iss:String,
    sub:String,
    name:String,
    admin:bool,
}


mod jwt_numeric_date {
    //! Custom serialization of DateTime<Utc> to conform with the JWT spec (RFC 7519 section 2, "Numeric Date")
    use chrono::{DateTime, TimeZone, Utc};
    use serde::{self, Deserialize, Deserializer, Serializer};

    /// Serializes a DateTime<Utc> to a Unix timestamp (milliseconds since 1970/1/1T00:00:00T)
    pub fn serialize<S>(date: &DateTime<Utc>, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let timestamp = date.timestamp();
        serializer.serialize_i64(timestamp)
    }

    /// Attempts to deserialize an i64 and use as a Unix timestamp
    pub fn deserialize<'de, D>(deserializer: D) -> Result<DateTime<Utc>, D::Error>
    where
        D: Deserializer<'de>,
    {
        Utc.timestamp_opt(i64::deserialize(deserializer)?, 0)
            .single() // If there are multiple or no valid DateTimes from timestamp, return None
            .ok_or_else(|| serde::de::Error::custom("invalid Unix timestamp value"))
    }
}



impl Claims {
    /// If a token should always be equal to its representation after serializing and deserializing
    /// again, this function must be used for construction. `DateTime` contains a microsecond field
    /// but JWT timestamps are defined as UNIX timestamps (seconds). This function normalizes the
    /// timestamps.
    pub fn new(iat: DateTime<Utc>, exp: DateTime<Utc>, iss:String, sub:String, name:String, admin:bool) -> Self {
        // normalize the timestamps by stripping of microseconds
        let iat = iat.date().and_hms_milli(iat.hour(), iat.minute(), iat.second(), 0);
        let exp = exp.date().and_hms_milli(exp.hour(), exp.minute(), exp.second(), 0);
        Self { iat, exp, iss, sub, name, admin }
    }
}



const KEY:&[u8;11] = b"torch_order";


pub fn encode_jwt(name:String,admin:bool) -> String{
    let mut header = Header::default();
    header.kid = Some("singing_key".to_owned());
    header.alg = Algorithm::HS512;

    let iat = Utc::now();
    let exp = iat + chrono::Duration::days(1);
    let xiaozhao_claims = Claims::new(iat,exp,"yangxiao".to_owned(),"mingjiao".to_owned(),name,admin);


    // let KEY = b"torch_order";
    let token = match encode(&header,&xiaozhao_claims,&EncodingKey::from_secret(KEY)) {
        Ok(t) => t,
        Err(e) => {
            error!("生成token错误，原因是:{:?}",e);
            return "".to_string()
        }
    };

    return token;
}


pub fn decode_jwt(token:String) -> bool {
    let mut algorithms = Vec::new();
    algorithms.push(Algorithm::HS512);
    let validation = Validation { algorithms,..Validation::default() };
    return match decode::<Claims>(
        &token,
        &DecodingKey::from_secret(KEY),
        &validation
        // &Validation::new(Algorithm::HS512),
    ) {
        Ok(_) => {
            true
        },
        Err(e) => match *e.kind() {
            ErrorKind::InvalidToken => {
                error!("无效的token");
                false
            }
            _ => {
                error!("错误的token,错误原因:{:?}", e);
                false
            }
        }
    };
}