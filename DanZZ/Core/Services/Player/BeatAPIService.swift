//
//  Segment.swift
//  DanZZ
//
//  Created by Hong Lu on 01/12/2025.
//

import Foundation

class BeatAPIService {
    static let shared = BeatAPIService()
    let apiUrl = "https://beat-api-388539729262.europe-west1.run.app/extract_beats" // endpoint deployed on google cloud run
    var beats:[Double]?
    
    func extractBeats(url: URL, completion: @escaping([Double]?, Error?)-> Void){
        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        let filename = url.lastPathComponent
        let mimeType = "video/mp4"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append((try! Data(contentsOf: url)))
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                
        URLSession.shared.uploadTask(with: request, from: body){ responseData, response, error in
            if let error = error{
                completion(nil, error)
                return
            }
            guard let responseData = responseData else{
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response data"]))
                return
            }
            
            do{
                if let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                   let beats = json["beats"] as? [Double]{
                    self.beats = beats
                    completion(beats, nil)
                } else {
                    completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"]))
                }
            }catch {
                completion(nil, error)
            }
            
        }.resume()
    }
    
    func beats_to_time(beatIndex: Int) -> Double? {
        guard let beats = self.beats else {
            print("beats not initilized")
            return nil }
        guard beatIndex >= 0 && beatIndex < beats.count else {
            print("beat index is invalid")
            return nil
        }
        print("return beats to time, \(beats[beatIndex])")
        return beats[beatIndex]
    }
    
    func get_last_beat() -> Double? {
        guard let beats = self.beats else {
            print("beats not initilized")
            return nil }
        return beats.last
    }
}

