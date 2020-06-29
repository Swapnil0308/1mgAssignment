//
//  ReachabilityToNetwork.swift
//  1mgAssignment
//
//  Created by Swapnil on 29/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//

import Foundation
import SystemConfiguration

public class ReachabilityToNetwork
{
    public func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
            {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        else
        {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        if flags.isEmpty
        {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
