//
//  PaginationData.swift
//  1mgAssignment
//
//  Created by Swapnil on 26/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// model data for pagination purpose during scroll of collectionview


import Foundation

public class PaginationData
{
    public var totalNoOfPages: Int?
    public var numberOfElementsInData: Int32?
    public var currentSizeOfPage: Int = 20
    public var currentPage: Int?

    init(totalPages: Int, elements: Int32, currentPage: Int)
    {
        self.totalNoOfPages = totalPages
        self.numberOfElementsInData = elements
        self.currentPage = currentPage
    }
}
