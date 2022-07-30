//
//  ContentView.swift
//  Shared
//
//  Created by Taegyeong Lee on 2022/07/29.
//

import SwiftUI

import SafariServices

import NetworkExtension
import SystemConfiguration.CaptiveNetwork


struct ContentView: View {
    var body: some View {
       
        NavigationView {
                Form {
                    List {
                        Section(header: Text("연결")){
                            ZStack {
                                VStack {
                                    Image("SoongfiLarge").resizable().scaledToFit()
                                    VStack(alignment: .leading ){
                                        Text("숭파이 연결하기").font(.title).fontWeight(.bold)
                                        Text("\n숭실대학교 교내 와이파이 연결 문제를 자동으로 진단하고 인터넷을 연결합니다.")
                                    }.padding()
                                }
                                NavigationLink(destination: WifiConnectView()){
                                        EmptyView()
                                }.opacity(0)
                            }.listRowInsets(EdgeInsets())
                        }
                        
                        Section(header: Text("더보기")) {
                                
                            NavigationLink("앱 정보", destination: AppInfoView())
                            }
                            
                        }.navigationTitle("숭파이")
            
            
                    }
        }
        
    }
}


struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}

struct WifiConnectView : View {

    @State private var ipAddress : String = ""
    @State private var macAddress : String = "00:00:00:00:00:00"
    
        @State private var showSafari = false
        @State private var urlString = "https://google.com"

    
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }

    func getInit() {
          ipAddress = getIPAddress()
    }
    
   
    
    var body: some View {
            VStack {
                ProgressView()
                Text("으악")
                Text("IP주소를 확인하는 중 : \(ipAddress)")
                Text("MAC주소를 확인하는 중 : \(macAddress)")
                Text("http://auth.soongsil.ac.kr/login/login.do?ipaddress=" + ipAddress + "&macaddress=" + macAddress + "&vlantag=0220&sysid=0001&btype=014&scode=&fwurl=product.tdk.com/en/search/set_distributor?back_url=/en/catalog/datasheets/beads_commercial_power_mpz2")
                Button(action: {
                            showSafari = true
                        }) {
                            Text("로그인하기")
                        }
                        // summon the Safari sheet
                        .sheet(isPresented: $showSafari) {
                            SafariView(url:URL(string: "http://auth.soongsil.ac.kr/login/login.do?ipaddress=" + ipAddress + "&macaddress=" + macAddress + "&vlantag=0220&sysid=0001&btype=014&scode=&fwurl=product.tdk.com/en/search/set_distributor?back_url=/en/catalog/datasheets/beads_commercial_power_mpz2")!)
                        }
            }.onAppear{getInit()}
    }
}


struct AppInfoView: View {
    var body: some View {
        
        ScrollView {
                Link("깃허브",
                     destination: URL(string: "https://hanarotg.github.io")!)
                Text("흐흫헤헤")
            Button("깃허브") {}
                .padding()
                .frame(width: 100)
                .background(Color(red: 0, green: 0, blue: 0.5))
                .controlSize(.large)
        }
        
    }
}
                        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
