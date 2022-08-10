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
    
    private var vlangtagArr = ["0110", "0220", "0550"]
    @State private var vlangtagSelected : String = "0110"
    
    @State private var showSafari = false
    @State private var urlString = "https://google.com"

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

    func getInit() {
        ipAddress = getIPAddress()
        
        let _ = print(ipAddress.count)
        
        // vlangtag 선택
        vlangtagSelected = vlangtagArr.randomElement()!
        
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
                            ConnectionHelpView()
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
                       
                    // summon the Safari sheet
                    .sheet(isPresented: $showSafari) {
                        SafariView(url:URL(string: "http://auth.soongsil.ac.kr/login/login.do?ipaddress=" + ipAddress + "&macaddress=" + macAddress + "&vlantag=" + vlangtagSelected + "&sysid=0001&btype=014&scode=&back_url=192.168.0.1/login/login.cgi")!)
                    }.onAppear{getInit()}
            
        }
        .padding()
        .frame(alignment: .bottom)
        
    }
    
}

struct ConnectionHelpView: View {
    
    @State private var showSafari = false
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("도움말").font(.title)
                Text("아래 가이드에 따라 가능한 여러 가지 방법을 시도해 보세요.\n").font(.subheadline).foregroundColor(Color.gray)
                
                VStack(alignment: .leading) {
                    Text("로그인 페이지 호출 실패").font(.title2)
                    Text("'숭파이 로그인'시 로그인 창이 나오지 않고\n라는 문구가 나오면 아래 단계를 진행해주세요.").font(.subheadline).foregroundColor(Color.gray)
                    VStack(alignment: .leading) {
                        Text("1. Soongsil_WIFI 연결을 끊어주세요.")
                        Text("2. Soongsil_WIFI에 다시 연결해주세요.")
                        Text("3. 아래 라우터 접속 시도를 눌러주세요.")
                        Text("[주의] 반드시 Soongsil_WIFI에 연결된 상태에서 진행해주세요!")
                            .font(.subheadline).foregroundColor(Color.gray)
                        
                        Button(action: {
                            showSafari = true
                                })
                                    {
                                    Text("숭파이 내부 라우터 접속 시도")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color.accentColor)
                                            .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                    .sheet(isPresented: $showSafari) {
                                        SafariView(url:URL(string: "http://192.168.0.1")!)
                                    }
                        Text("4-1. 로그인 화면이 뜨면 로그인합니다.")
                        Text("4-2. 로그인 화면이 뜨지 않는 경우(무한로딩) 숭파이 앱을 재실행해 주세요.")
                        
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
                
                
            }.padding()
                
                 }
    }
}


struct AppInfoView: View {
    
    @Environment(\.openURL) private var openURL

    
    var body: some View {
        
        ScrollView {
            VStack {
               
                VStack(alignment: .leading) {
                    
                    Text("후원하기").font(.title)
                    Text("여러분의 소중한 지원 감사합니다.\n잘 쓰겠습니다.").foregroundColor(Color.gray)
                    
                    Button(action: {
                        if let url = URL(string: "https://toss.me/googoogoo"){
                            openURL(url)
                        }
                    })
                    {
                        Text("💸 후원하기(토스익명송금)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }

                    
                    }.padding()
                    
                
            
                
                VStack(alignment: .leading) {
                    Text("건의 및 버그 신고").font(.title)
                    Text("아직 많은 점이 부족합니다.\n실제로 이용하실 때 불편함이나 건의할 사항 있으시다면\n언제든지 작성 부탁드립니다.").foregroundColor(Color.gray)
                    
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
                    Text("개발자 정보").font(.title)
                    Text("안녕하세요.").foregroundColor(Color.gray)
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/hanarotg"){
                            openURL(url)
                        }
                    })
                    {
                        Text("깃허브")
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
