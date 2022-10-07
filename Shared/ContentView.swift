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
        TabView {
                WifiConnectView()
                .tabItem {
                  Image(systemName: "wifi")
                  Text("조치")
                }
                AppInfoView()
                .tabItem {
                  Image(systemName: "info")
                  Text("정보")
                }
            }
    }
}

struct WifiConnectView : View {
    
    @Environment(\.openURL) private var openURL

    var body: some View {
        
        ScrollView {
            
            VStack(alignment : .leading) {
                
                VStack(alignment : .leading) {
                    
                    Text("숭파이").font(.largeTitle).fontWeight(.bold)
                    Text("숭파이는 공용 와이파이 인터넷 연결 문제 해결 방법을 안내합니다.").foregroundColor(.gray)
                    
                    
                    
                }
                
                Spacer().frame(minHeight: 30)

                
                VStack(alignment : .leading) {
                    Text("인터넷 접속 시도").font(.title2)
                    Text("아래 두 조건을 만족해야 합니다.").foregroundColor(.gray)
                    
                    Divider()
                    
                    Text("1) 공용 와이파이에 연결된 상태여야 합니다.")
                    
                    Image("WifiConnected").resizable().scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    Text("2) 인터넷 사용이 불가능한 상태여야 합니다.")
                    
                    Image("InternetNotConnected").resizable().scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 1)
                }
                
                VStack(alignment : .leading) {
                    Text("인터넷 접속 시도").font(.title2)
                    Button(action: {
                        if let url = URL(string: "http://192.168.0.1"){
                            openURL(url)
                        }
                    })
                    {
                        Text("시도 #1 라우터 접속")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "http://www.gstatic.com/generate_204"){
                            openURL(url)
                        }
                    })
                    {
                        Text("시도 #2 gstatic")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "http://captive.apple.com"){
                            openURL(url)
                        }
                    })
                    {
                        Text("시도 #3 apple captive portal")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "http://captive.apple.com"){
                            openURL(url)
                        }
                    })
                    {
                        Text("시도 #3 apple captive portal")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                }
                
                Spacer().frame(minHeight: 30)
                
                VStack(alignment : .leading) {
                    Text("참고").font(.title2)
                    
                    Button(action: {
                        if let url = URL(string: "https://developer.apple.com/news/?id=q78sq5rv"){
                            openURL(url)
                        }
                    })
                    {
                        Text("How to modernize your captive network")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.accentColor)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
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
