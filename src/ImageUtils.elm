module ImageUtils exposing (..)

import Http


cloudinaryUrl : Bool -> String
cloudinaryUrl isThumb =
    let
        baseURL =
            "https://res.cloudinary.com/mota/image/fetch/"
    in
        if (isThumb) then
            baseURL ++ "w_178,h_100,c_thumb/"
        else
            baseURL ++ "w_1200,h_675,ar_16:9/"


mainImage : String -> String
mainImage s3Url =
    (cloudinaryUrl False) ++ (Http.encodeUri s3Url)


thumbnailImage : String -> String
thumbnailImage s3Url =
    (cloudinaryUrl True) ++ (Http.encodeUri s3Url)
