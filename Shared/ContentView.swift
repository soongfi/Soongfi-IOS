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
                                        Text("숭파이 인터넷 연결하기").font(.title).fontWeight(.bold)
                                        Text("\n숭실대학교 교내 와이파이 인터넷 연결 시도를 위해 로그인 화면 호출을 시도합니다.")
                                    }.padding()
                                }
                                NavigationLink(destination: WifiConnectView()){
                                        EmptyView()
                                }.opacity(0)
                            }.listRowInsets(EdgeInsets())
                        }
                        
                        Section(header: Text("더보기")) {
                                
                            NavigationLink("기타 정보", destination: AppInfoView())
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

    @State private var loadingMessage : String = ""
    
    @State private var ipAddress : String = "11.11.11.11"
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
        
        let _ = print(ipAddress.count)
        
        if(ipAddress.count > 16){
            loadingMessage = "[주의] 현재 교내 와이파이에 접속하지 않은 상태입니다. 로그인 후 숭실대학교 교내 와이파이(Soongsil_WIFI)에 접속해 주세요."
            ipAddress = "22.22.22.22"
            sleep(1)
        }
                
        showSafari = true
        
    }
    
   
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Image("Connected").resizable().scaledToFit()
                    Text("연결되었습니다!").padding()
                    Text("로그인 페이지가 나타나지 않는 경우 아래 숭파이 로그인 버튼을 누르세요.\n사용자 네트워크 환경에 따라 여러 번 로그인 해야 할 수도 있습니다.").font(.subheadline).foregroundColor(Color.gray)
                    
                    Button(action: {
                                showSafari = true
                            })
                                {
                                Text("숭파이 로그인")
                            }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                            .cornerRadius(8)
                            // summon the Safari sheet
                            .sheet(isPresented: $showSafari) {
                                SafariView(url:URL(string: "http://auth.soongsil.ac.kr/login/login.do?ipaddress=" + ipAddress + "&macaddress=" + macAddress + "&vlantag=0220&sysid=0001&btype=014&scode=&fwurl=product.tdk.com/en/search/set_distributor?back_url=/en/catalog/datasheets/beads_commercial_power_mpz2")!)
                            }
                    
                }.padding()
               
                
                
                VStack(alignment: .leading) {
                    
                    
                    
                    
                    Text("도움말").font(.title)
                    Text("와이파이 연결을 껐다가 다시 켜보세요.").font(.subheadline).foregroundColor(Color.gray)
                    Button(action: {
                       
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)

                            })
                                {
                                Text("설정 바로가기")
                            }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color.accentColor)
                                .background(Color(.systemGray6))
                            .cornerRadius(8)
                }.padding()
                
            }
            .onAppear{getInit()}
        }
        .padding()
        .frame(maxWidth: .infinity)
            
    
        }
    
}


struct AppInfoView: View {
    var body: some View {
        
        ScrollView {
            VStack {
               
                VStack(alignment: .leading) {
                    
                    Text("후원하기").font(.title)
                    Text("여러분의 소중한 지원 감사합니다.\n잘 쓰겠습니다.").foregroundColor(Color.gray)
                    
                    Link("💸 후원하기(토스익명송금)", destination: URL(string: "https://toss.me/googoogoo")!)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                  
                    
                    }.padding()
                    
                
            
                
                VStack(alignment: .leading) {
                    Text("건의 및 버그 신고").font(.title)
                    Text("아직 많은 점이 부족합니다.\n실제로 이용하실 때 불편함이나 건의할 사항 있으시다면\n언제든지 작성 부탁드립니다.").foregroundColor(Color.gray)
                    
                    Link("건의 및 버그 신고", destination: URL(string: "https://toss.me/googoogoo")!)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                    }.padding()
            
        
                VStack(alignment: .leading) {
                    Text("개발자 정보").font(.title)
                    Text("안녕하세요.").foregroundColor(Color.gray)
                    Link("깃허브",
                         destination: URL(string: "https://github.com/hanarotg")!)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.accentColor)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    Link("개발자 블로그",
                         destination: URL(string: "https://hanarotg.github.io")!)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.accentColor)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }.padding()
            
            }
        }
    }
}
                        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
