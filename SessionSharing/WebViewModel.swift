//
//  WebViewModel.swift
//  SessionSharing
//
//  Created by Noel Achkar on 7/24/19.
//  Copyright © 2019 Noel Achkar. All rights reserved.
//

import Foundation

class WebViewModel {

    var webViewData: [String : Any]
    
    init(webViewData: [String : Any]) {
        self.webViewData = webViewData
    }
    
    func processWebCookies(complete: @escaping (URLRequest) -> ()) {
        var loginDecoded = RequestLoginToken.init(json: webViewData)
        let token = loginDecoded?.token
        let array = token!.convertToArray()
        
        var cookiesArray = Array<HTTPCookie>()
        for cookie in array {
            var cookies = TokenItem.init(json: (cookie as! [String : Any]))
            
            //The date in user_credentials should be updated in order to validate the cookies
            if cookies?.name == "user_credentials" {
                var value = cookies?.value.components(separatedBy: "%3A")[0]
                value?.append("%3A%3A\(Utilities.getNextYear())-07-24T05%3A59%3A48-04%3A00")
                cookies?.value = value!
            }
            
            let httpCookie = HTTPCookie(properties: [
                .domain: cookies!.domain,
                .path: cookies!.path,
                .name: cookies!.name,
                .value: cookies!.value,
                .secure: cookies!.secure ? "TRUE" : "FALSE",
                .expires: NSDate(timeIntervalSinceNow: TimeInterval(cookies!.expirationDate))
                ])!
            cookiesArray.append(httpCookie)
            //            webView.configuration.websiteDataStore.httpCookieStore.setCookie(httpCookie)
        }
        
        var request = URLRequest.init(url: URL.init(string: (loginDecoded?.site.validateUrl())!)!)
        
        let cookieDict = HTTPCookie.requestHeaderFields(with: cookiesArray)
        if let cookieStr = cookieDict["Cookie"] {
            request.addValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
        complete(request)
        
        //        request.addValue("__ssid=392997aa-ce67-4d96-a73d-de0ad794f7bf; _ga=GA1.2.22338313.1482157521; _gat=1; _cb=DI3FOzCY4oom-HN03; _cb_ls=1; _cb_svref=https%3A%2F%2Fwww.kickstarter.com%2F; woe_id=d3JPQ2lwOWNRQTNmWFFlWENqUlFaUT09LS1RT2oxYk0xRWhxVUJWSW0zWEw0bW9RPT0%3D--31f1031013a257814194afdca74afc2fc4c3d2a8; _chartbeat2=.1482157524328.1482157549367.1.BEb9Z1Wrv9XB84-kdWYjxODHVtib; _ksr_session=cXJzUU9sa0JYMG1UUE1NY0V0Q2tnd0NlQmNYak02U01kMTFVNkdWS3R1SGhNa2xydWZrTllqUWVDR0YraTBENS9ESEs4UXEweWM5UWtUeHg2dUI4aTJMZ2l3VUJheG5ZSGVsVWJCRDdFMDZVbDBCa2tJSzlyVm9uY3Z3STFxbDRwU3lRRmNMRWVha3RtNEFoTDVnM2oxY0IxazhUTkFjelVZY0JVN1kzQUdybjByWStsV2Ixc2lCVUp0V3dPZHBlMDhBUmpIams2LzZVWXJWUTJNU25maWFvWTk4UUh4RndCTTAwRVJlRXhPK2U0VDk0TUQrU1hqd3R2LzZneXRleVU4SE04SDdLOHR3YkFKWGFYS2t5andJd1ljQXc0M1hNZlNkWXIxRVdPelRPYTJLeHY2OFI0TE50UUFLMUpQS2IvQzhwc2lyRkJ1NmdZMis4OWErM21PWmtvUWZoVWowMWEzbEc0eUdlNTNNRWhadFdBVEZrWmt4ZDhhS0toM1NIc2lvWHJxbVNLMS9GcjNBWGpZNVAyUGdDRXhPWlFMR3pRT3l0TE5CZUY1NVBKdnV2bWVaN0x1ZzZYLzJWQUZCV2swVDQ5dEdvUm05UzgveUdzUHllSmc9PS0tdzdDQVBsclYzWEc5cFQxV1hXdTNsdz09--0a5c16c8b73e6bc8323526f751188a73a71e7429; lang=en; last_page=https%3A%2F%2Fwww.kickstarter.com%2F; local_offset=-852; lux_uid=148215751583512188; request_time=Mon%2C+19+Dec+2016+14%3A25%3A48+-0000; user_analytics_properties=%7B%22user_uid%22%3A716249931%2C%22user_facebook_account%22%3Afalse%2C%22user_backed_projects_count%22%3A0%2C%22user_launched_projects_count%22%3A0%7D; user_credentials=e5047615f3e81ea29c34ccd59c94e62e425c98612cc789ecf330547cedcf1f2e8d5b9af582ba02491ee9c6c51a785eba737946c0b4b038c8a7ed1885b1083866%3A%3A32699761%3A%3A2020-07-24T05%3A59%3A48-04%3A00; vis=e8038bab47f6b212-ffddb55d9e28bb18-95e0ba8d7d81c970v1", forHTTPHeaderField: "Cookie")
        
        //         request.addValue("vis=29dfbbeaece7511c-ee6abc96ef563c2e-9d4f823397328fcfv1; lang=en; last_page=https%3A%2F%2Fwww.kickstarter.com%2F; woe_id=d3JPQ2lwOWNRQTNmWFFlWENqUlFaUT09LS1RT2oxYk0xRWhxVUJWSW0zWEw0bW9RPT0%3D--31f1031013a257814194afdca74afc2fc4c3d2a8; _ga=GA1.2.104863712.1563962365; _gid=GA1.2.1179681449.1563962365; _gat=1; __ssid=7ce6842e8d6b8e3133504309945e37e; user_credentials=e5047615f3e81ea29c34ccd59c94e62e425c98612cc789ecf330547cedcf1f2e8d5b9af582ba02491ee9c6c51a785eba737946c0b4b038c8a7ed1885b1083866%3A%3A32699761%3A%3A2020-07-24T05%3A59%3A48-04%3A00; user_analytics_properties=%7B%22user_uid%22%3A1708975285%2C%22user_facebook_account%22%3Afalse%2C%22user_backed_projects_count%22%3A0%2C%22user_launched_projects_count%22%3A0%7D; _ksr_session=QkkxWmFLNytaSy9ZRVJVZWZxNXoxUTA3TUwwKzgveWFyRm9Nb1dSM0VHTXRhN1V3TE1ub0lTeDczbC9abTZLUUtSZFp4OVJacGtuYUdEUUVBbWNCbUNOdlVyVlBGc2V4R2FGMEVCQ3VnMjIraVhVdDNvWVFYeCtSWTZkWGlpRnVQRkZUWFpVMUhldTg2SEFJYW45QlR4c05VNHJaMlZsQlFjVGtBYmtIdTFDWWd5djNGSTJhV1FYUWtjamlLQ0xXVmF2OHNrbFVremk3RHo1T0RiblF6SnZ5YWFQNTF5cG03WUNSUGtCQ0tML1pUN0RJWDcwSVEwR1pENlhmczgzVkFDZU5adnVOK01qMmVFdEVQRUJBN0p4WS9hdmpRRnZrSzNIenBPTzJlZllJb25ldWxNNDk0bnpCTVJXWkFoYlo3c0orTXFxSGVHWVpwaTc5aWswbVJsRjBSMHZoaDduNElrcEtLODA0eUU0VS9idFhOc3JOenczYno1S1hUczBUMHhvWURZUE4yakZFWmJFeDlNN1lJcngwbVRvQW9haXVsTlFxT1VYbXE1b2VkQzFITFV1V1U4QS9EK25QU0xSNC0tWVIvUGF3NFVrKzJuK2Q0UWZST1Z1UT09--abf430ea88dd6200aa249bd7a3685dc912630319; request_time=Wed%2C+24+Jul+2019+09%3A59%3A49+-0000; local_offset=-368", forHTTPHeaderField: "Cookie")
    }
}

