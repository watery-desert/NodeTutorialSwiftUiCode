//
//  AuthenticationView.swift
//  NodeTutorialSwiftUiCode
//
//  Created by Ahmed on 26/10/22.
//



import SwiftUI

struct LoggedInUser: Codable {
    var token: String
    var userId: String
    
    enum CodingKeys: CodingKey {
        case token
        case userId
    }
}


struct User: Codable {
    var name: String?
    var email: String
    var password: String
    
    enum CodingKeys: CodingKey {
        case name
        case email
        case password
    }
}


struct MyApp: View {
    
    @State private var isLoggedIn = false
    @State private var token: String = ""
    
    
    
    var body: some View {
        if isLoggedIn {
            TodoHomeAuth(isLoggedIn: $isLoggedIn, token: $token)
        } else {
            AuthenticationView(isLoggedIn: $isLoggedIn, token: $token)
        }
    }
}

struct AuthenticationView: View {
    @State private var showSignUp = true
    @State private var nameField: String = ""
    @State private var emailField: String = ""
    @State private var passwordField: String = ""
    @State private var user: User? = nil
    
    @Binding var isLoggedIn: Bool
    @Binding var token: String
    
    
    
    
    
    var body: some View {
        
        Button("toggle auth") {
            showSignUp.toggle()
        }
        
        if showSignUp {
            TextField("Name", text: $nameField)
                .padding()
        }
        
    
        TextField("Email", text: $emailField)
            .padding()
        TextField("Password", text: $passwordField)
            .padding()
        Button(showSignUp ?"SignUp" : "LogIn") {
            if showSignUp {
                user = User(name: nameField, email: emailField, password: passwordField)
                Task {
                    do {
                        
                        try await signUpHandler()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                user = User( email: emailField, password: passwordField)
                Task {
                    do {
                        
                        try await loginHandler()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .buttonStyle(.bordered)
    }
    
    private func signUpHandler() async throws {
        let url = URL(string: "http://localhost:8000/auth/signup")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedTodo = try? JSONEncoder().encode(user) else {
            return
        }
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedTodo)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
            
            print("Error \(errorData)")
            throw URLError(.cannotParseResponse)
        }
        
        let jsonData =  try JSONDecoder().decode(LoggedInUser.self, from: data)
        isLoggedIn = true
        token = jsonData.token
        print(jsonData.userId)
        print("token: \(token)")
     
    }
    
    private func loginHandler() async throws {
        let url = URL(string: "http://localhost:8000/auth/login")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encodedTodo = try? JSONEncoder().encode(user) else {
            return
        }
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodedTodo)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let errorData = try JSONDecoder().decode(ErrorData.self, from: data).message
            
            print("Error \(errorData)")
            throw URLError(.cannotParseResponse)
        }
        
        
        let jsonData =  try JSONDecoder().decode(LoggedInUser.self, from: data)
        isLoggedIn = true
        token = jsonData.token
        print(jsonData.userId)
    }
}


