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


extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}

struct ContentView: View {
    
    // 디바이스 ip 주소 반환 함수,
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

    // 유효한 auth.soongsil.ac.kr 로그인 주소를 생성하는 함수
    func getURL() -> String {
        
        // IP주소를 파악
        var ipAddress = getIPAddress()
                
        // vlangtag 선택
        let vlangtagArr = ["0110", "0220", "0550"]
        let vlangtagSelected = vlangtagArr.randomElement()!
        
        // 만약 모바일 데이터의 경우 & IPv6의 경우 가짜 아이피로 변경
        if(ipAddress.count > 16){
            ipAddress = "010.020.30.22"
        }
        
        // uuid를 통해 가상 MAC주소 포멧을 생성
        let uuid = NSUUID().uuidString
        let macAddressTmp = uuid.substring(from: 24, to : 25) + ":"
            + uuid.substring(from: 26, to : 27) + ":"
            + uuid.substring(from: 28, to : 29) + ":"
            + uuid.substring(from: 30, to : 31) + ":"
            + uuid.substring(from: 32, to : 33) + ":"
            + uuid.substring(from: 34, to : 35)
        let macAddress = macAddressTmp
        // let _ = print(macAddress)
        
        // 위 네트워크 정보를 통해 숭파이 로그인 페이지를 생성
        return "http://auth.soongsil.ac.kr/login/login.do?ipaddress=" + ipAddress + "&macaddress=" + macAddress + "&vlantag=" + vlangtagSelected + "&sysid=0001&btype=014&scode=&back_url=192.168.0.1/login/login.cgi"
        
    }

    
    @State private var showSafariSoongfiLogin = false
    @State private var showSafariRouterLogin = false
    @State private var showHelp = false
    @State private var connection = false
    
    @State private var shadowRadius: CGFloat = 0
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            
            VStack {
             
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("숭파이 beta")
                            .foregroundColor(Color(.systemGray))
                            .fontWeight(.bold)
                    }
                    
                    // 도움말 버튼
                    Button(action: { showHelp = true }){
                        Image(systemName: "info.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(Color(.systemGray3))
                    }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .sheet(isPresented: $showHelp) {
                            ConnectionHelpView(showHelpView: $showHelp)
                        }
                }
                
                Spacer()
                
                // auth.soongsil.ac.kr 로그인 서버로 직접 접속을 시도합니다.
                // ip 및 mac vtag 등의 접속 요건 파라미터를 랜덤으로 생성합니다.
                Button(action: {
                    showSafariSoongfiLogin = true
                })
                {
                    VStack(spacing: 0){
                        Image("SoongfiLarge")
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                }
                .sheet(isPresented: $showSafariSoongfiLogin) {
                    let URLtmp = getURL()
                    SafariView(url:URL(string : URLtmp)!)
                }
                
                .cornerRadius(100)
                .shadow(radius: shadowRadius, y: 2)
                .onAppear{
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        shadowRadius = 10
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("위 와이파이 버튼을 눌러\n숭실대학교 로그인 페이지 호출 시도해보세요.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.systemGray))
                
                    // 인터넷이 연결되어 있는 경우
                    if connection == true {
                        Text("인터넷에 연결되어 있는 것 같아요!").foregroundColor(.white)
                    }
                }
                
            }
            .frame(maxHeight: .infinity)
                        
            VStack {
                
                // 라우터 아이피로 접속을 시도합니다.
                Button(action: {
                    showSafariRouterLogin = true
                })
                {
                    Text("로그인 페이지 호출 실패")
                        .padding()
                        .frame(maxWidth: 536)
                        .foregroundColor(Color.accentColor)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showSafariRouterLogin) {
                    SafariView(url:URL(string: "http://192.168.0.1")!)
                }
                
            }.frame(maxHeight: .infinity, alignment: .bottom)
            
        }.padding()
        .frame(maxWidth: .infinity)
        .background(connection ? Color.accentColor : Color(.systemGray6))
    }
}


struct SafariView: UIViewControllerRepresentable {
    
    let url : URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}




struct ConnectionHelpView: View {
    
    
    @Binding var showHelpView: Bool
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
                Button(action: { self.showHelpView.toggle() }){
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color(.systemGray3))
                }.frame(maxWidth: .infinity, alignment: .trailing)
        
           
            Text("도움말").font(.title)
            Text("아래 가이드에 따라 가능한 여러 가지 방법을 시도해 보세요.").font(.subheadline).foregroundColor(Color.gray)
            
        }.padding()
        
        ScrollView {
            VStack(alignment: .leading) {
                
                
                VStack(alignment: .leading) {
                    Text("인터넷 속도가 느려요, 자꾸 끊겨요").font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("1. Soongsil_WIFI 연결을 끊어주세요.")
                        Text("2. 인터넷이 되는 다른 와이파이(또는 모바일 데이터)에 연결하세요.")
                        Text("3. 숭파이 로그인 버튼을 눌러 로그인해주세요.")
                        Text("4. 다시 Soongsil_WIFI에 연결하여 인터넷 속도를 확인해 주세요.")
                    }.padding()
    
                }.padding()
               
                VStack(alignment: .leading) {
                    Text("기타").font(.title2)
                    
                    Button(action: {
                        if let url = URL(string: "https://forms.gle/CiwkYGa2fhu4zuZFA"){
                            openURL(url)
                        }
                    })
                    {
                        Text("피드백(구글 폼)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://hanarotg.github.io/others/soongfi/"){
                            openURL(url)
                        }
                    })
                    {
                        Text("홈페이지")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.accentColor)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://hanarotg.github.io/others/soongfi/private-policy.html"){
                            openURL(url)
                        }
                    })
                    {
                        Text("개인정보처리방침")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.accentColor)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
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
