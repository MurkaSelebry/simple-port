package middlewares

import (
	"context"
	"errors"
	"log"
	"main/src/models"
	"net/http"
	"strings"
)

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		//token := r.Header.Get("Authorization")
		cookie, err := r.Cookie("jwt")
		if err != nil {
			switch {
			case errors.Is(err, http.ErrNoCookie):
				token := r.Header.Get("Authorization")
				if token == "" {
					http.Error(w, "Missing token in request", http.StatusUnauthorized)
					log.Println("Unauthorized request: Missing token")
					return
				}
				splitToken := strings.Split(token, "Bearer ")
				var reqToken = splitToken[1]

				if reqToken == "" {
					http.Error(w, "Invalid token format. Bearer token required", http.StatusUnauthorized)
					log.Println("Unauthorized request: Invalid token format")
					return
				}

				claims, err := models.DecodeToken(reqToken)
				if err != nil {
					http.Error(w, "Unauthorized to perform request. Invalid token", http.StatusUnauthorized)
					log.Printf("Unauthorized request: Invalid token - %v", err)
					return
				}

				ctx := context.WithValue(r.Context(), "userId", claims.Id)
				log.Printf("Authenticated user: %v", claims.Id)
				next.ServeHTTP(w, r.WithContext(ctx))
				return
			default:
				log.Println(err)
				http.Error(w, "server error", http.StatusInternalServerError)
			}
			return
		}
		token := "Bearer " + cookie.Value
		// if token == "" {
		// 	cookie, err := r.Cookie("jwt")
		// 	if err != nil {
		// 		switch {
		// 		case errors.Is(err, http.ErrNoCookie):
		// 			http.Error(w, "cookie not found", http.StatusBadRequest)
		// 		default:
		// 			log.Println(err)
		// 			http.Error(w, "server error", http.StatusInternalServerError)
		// 		}
		// 		return
		// 	}
		// 	token = "Bearer " + cookie.Value
		// 	if token == "" {
		// 		http.Error(w, "Unauthorized to perform request. Please get a valid API key", http.StatusUnauthorized)
		// 		log.Println("Unauthorized request: No token provided")
		// 	}
		// 	return
		// }
		// Extract Bearer token
		splitToken := strings.Split(token, "Bearer ")
		var reqToken = splitToken[1]

		if reqToken == "" {
			http.Error(w, "Invalid token format. Bearer token required", http.StatusUnauthorized)
			log.Println("Unauthorized request: Invalid token format")
			return
		}

		claims, err := models.DecodeToken(reqToken)
		if err != nil {
			http.Error(w, "Unauthorized to perform request. Invalid token", http.StatusUnauthorized)
			log.Printf("Unauthorized request: Invalid token - %v", err)
			return
		}

		ctx := context.WithValue(r.Context(), "userId", claims.Id)
		log.Printf("Authenticated user: %v", claims.Id)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
