//
//  NetworkDataLoader.swift
//  App
//
//  Created by Kenny on 2/29/20.
//
import Foundation

protocol NetworkDataLoader {
    func loadData(from request: URLRequest, completion: @escaping( Data?, Error?) -> Void)
    func loadData(from url: URL, completion: @escaping( Data?, Error?) -> Void)
}
