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
                                        Text("\n숭실대학교 교내 와이파이 인터넷 연결 시도를 위해 로그인 화면을 호출합니다.")
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
            
            WifiConnectView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        
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

struct WifiConnectView : View {

    @State private var loadingMessage : String = ""
    
    @State private var showSafari = false

    @State private var showHelp = false
    

    
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

    
    func getURL() -> String {
        
        // IP주소를 파악
        var ipAddress = getIPAddress()
                
        // vlangtag 선택
        let vlangtagArr = ["0110", "0220", "0550"]
        let vlangtagSelected = vlangtagArr.randomElement()!
        
        // 만약 모바일 데이터의 경우 & IPv6의 경우 가짜 아이피로 변경
        if(ipAddress.count > 16){
            loadingMessage = "[주의] 현재 교내 와이파이에 접속하지 않은 상태입니다. 로그인 후 숭실대학교 교내 와이파이(Soongsil_WIFI)에 접속해 주세요."
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
    
   
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Image("Connected").resizable().frame(width: 100, height: 100)
                    Text("로그인 페이지가 나타나지 않는 경우\n아래 숭파이 로그인 버튼을 눌러주세요.\n\n사용자 네트워크 환경에 따라\n여러 번 로그인 해야 할 수도 있습니다.").font(.subheadline).foregroundColor(Color.gray).frame(alignment: .leading)

                }.padding()
            
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
    
        
        VStack {

            Button(action: {
               
                showHelp = true

                    })
                        {
                        Text("문제가 있나요?")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color.accentColor)
                                .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }.sheet(isPresented: $showHelp) {
                            ConnectionHelpView(showHelpView: $showHelp)
                        }
            
            Button(action: {
                        showSafari = true
                    })
                        {
                        Text("숭파이 로그인")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                       
                    
        }
        // summon the Safari sheet
        .sheet(isPresented: $showSafari) {
            let a = getURL()
            SafariView(url:URL(string : a)!)
        }
        .padding()
        .frame(alignment: .bottom)
        .onAppear{
            // 숭파이 로그인 웹 페이지 띄우기
            showSafari = true
        }
        
    }
    
}


struct ConnectionHelpView: View {
    
    @State private var showSafari = false
    
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
            Text("아래 가이드에 따라 가능한 여러 가지 방법을 시도해 보세요.\n").font(.subheadline).foregroundColor(Color.gray)
            
        }.padding()
        
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("로그인 페이지 호출 실패").font(.title2)
                    Text("'숭파이 로그인'시 로그인 창이 나오지 않고\n라는 문구가 나오면 아래 단계를 진행해주세요.").font(.subheadline).foregroundColor(Color.gray)
                    VStack(alignment: .leading) {
                        Text("1. 아래 라우터 접속 시도를 눌러주세요.")
                        Text("[주의] 반드시 Soongsil_WIFI에 연결된 상태에서 진행해주세요!")
                            .font(.subheadline).foregroundColor(Color.gray)
                        
                        Button(action: {
                            showSafari = true
                                })
                                    {
                                    Text("숭파이 라우터 접속 시도")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color.accentColor)
                                            .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                    .sheet(isPresented: $showSafari) {
                                        SafariView(url:URL(string: "http://192.168.0.1")!)
                                    }
                        Text("2-1. 로그인 화면이 뜨면 로그인합니다.")
                        Text("2-2. 로그인 화면이 뜨지 않는 경우(무한로딩) Soongsil_WIFI 재연결 후 숭파이 앱을 재실행해 주세요.")
                        
                    }.padding()
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("인터넷 속도가 느려요 & 자꾸 끊겨요").font(.title2)
                    Text("Soongsil_WIFI 인터넷이 비정상적으로 느린 경우\n간헐적으로 연결이 끊기는 경우\n아래 단계를 진행해주세요.").font(.subheadline).foregroundColor(Color.gray)
                    
                    VStack(alignment: .leading) {
                        Text("1. Soongsil_WIFI 연결을 끊어주세요.")
                        Text("2. 인터넷이 되는 다른 와이파이(또는 모바일 데이터)에 연결하세요.")
                        Text("3. 숭파이 로그인 버튼을 눌러 로그인해주세요.")
                        Text("4. 다시 Soongsil_WIFI에 연결하여 인터넷 속도를 확인해 주세요.")
                    }.padding()
                }.padding()
               
                VStack(alignment: .leading) {
                    Text("버그 신고").font(.title2)
                    Text("위 가이드라인을 여러번 시도했음에도\n숭파이 인터넷 접속에 문제가 있는 경우\n아래 버그 신고를 통해 알려주세요! 직접 확인해보겠습니다.").font(.subheadline).foregroundColor(Color.gray)
                    
                    Button(action: {
                        if let url = URL(string: "https://forms.gle/CiwkYGa2fhu4zuZFA"){
                            openURL(url)
                        }
                    })
                    {
                        Text("버그 신고(구글 폼)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                }.padding()
                
                
            }
                
        }
    }
}


struct AppInfoView: View {
    
    @Environment(\.openURL) private var openURL

    
    var body: some View {
        
        ScrollView {
            VStack {
               
                VStack(alignment: .leading) {
                    Text("건의 및 버그 신고").font(.title)
                    
                    Button(action: {
                        if let url = URL(string: "https://forms.gle/CiwkYGa2fhu4zuZFA"){
                            openURL(url)
                        }
                    })
                    {
                        Text("건의 및 버그 신고")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                
                    }.padding()
            
        
                VStack(alignment: .leading) {
                    Text("앱 정보").font(.title)
                    
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
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/hanarotg"){
                            openURL(url)
                        }
                    })
                    {
                        Text("개발자 깃허브")
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
