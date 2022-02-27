//
//  MenuController.swift
//  RestaurantApp
//
//  Created by Mohamed Maged on 25/02/2022.
//

import Foundation
import UIKit

class MenuController {
    
    enum MenuControllerError: Error, LocalizedError {
            case categoriesNotFound
            case menuItemsNotFound
            case orderRequestFailed
            case imageDataMissing
        }
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
   
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name:
               MenuController.orderUpdatedNotification, object: nil)
        }
    }

    static let shared = MenuController()
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    typealias MinutesToPrepare = Int
    
    func fetchCategories(completion: @escaping (Result<[String],Error>) -> Void) {
        
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: categoriesURL)
        { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let categoriesResponse = try
                    jsonDecoder.decode(CategoriesResponse.self,
                                       from: data)
                    completion(.success(categoriesResponse.categories))
                } catch {
                    completion( .failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping (Result<[MenuItem]?,Error>) -> Void) {
        
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL)
        { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
                    completion(.success(menuResponse.items))
                } catch {
                    completion(.failure(error))
                    
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<MinutesToPrepare, Error>) -> Void) {
        
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let orderResponse = try
                    jsonDecoder.decode(OrderResponse.self, from: data)
                    completion(.success(orderResponse.prepTime))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchImage(from url: URL) async throws -> UIImage {
            let (data, response) = try await URLSession.shared.data(from: url)
        
            guard let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 else {
                throw MenuControllerError.imageDataMissing
            }
        
            guard let image = UIImage(data: data) else {
                throw MenuControllerError.imageDataMissing
            }
        
            return image
        }
}

