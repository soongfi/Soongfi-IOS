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
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationView {
                
          Form {
                            VStack {
                                Text("숭파이는 공용 네트워크 문제 해결 도구입니다")
                            }
                            List {
                                Section(header: Text("상황별 조치")){
                                    
                                    NavigationLink {
                                        InternetNotConnectHelpBefore()
                                    } label: {
                                        Label("공용 와이파이 인터넷이 안돼요", systemImage: "wifi.exclamationmark")
                                    }.isDetailLink(false)
                        
                                }
                                
                                Section(header: Text("피드백")) {
                                    
                                    Link(destination: URL(string:  "https://forms.gle/CiwkYGa2fhu4zuZFA")!) {
                                        Label("버그 신고 및 건의", systemImage: "envelope")
                                    }
                                    
                                }
                                
                                Section(header: Text("더보기")) {
                                    
                                    Link(destination: URL(string:  "https://hanarotg.github.io/others/soongfi/")!) {
                                        Label("홈페이지", systemImage: "safari")
                                    }
                                    
                                    Link(destination: URL(string:  "https://hanarotg.github.io/others/soongfi/private-policy.html")!) {
                                        Label("개인정보 처리방침", systemImage: "person.fill")
                                    } 
                                                                        
                                }
                                }.navigationTitle("숭파이")

                            }
                    
                }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InternetNotConnectHelpBefore : View {
    
    var body: some View {
            VStack {
                ScrollView {
                    
                    VStack {
                        
                        VStack(alignment: .leading) {
                            
                            Text("공용 와이파이에 연결되어 있습니다.")
                            
                            Image("WifiConnected").resizable().scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 1)
                            
                            Spacer().frame(height: 50)
                            
                            Text("공용 와이파이에 연결되어 있지만\n인터넷 사용이 불가능합니다.")
                            
                            Image("InternetNotConnected").resizable().scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 1)
                            
                        }
                    }.padding()
                }
                
                NavigationLink(destination: InternetNotConnectedHelpList()) {
                        Text("동일한 문제를 겪고 있습니다.")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    
                }.isDetailLink(false).navigationTitle("문제 인식").padding()
                
                
            }
    }
}


struct InternetNotConnectedHelpList: View {
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                Button(action: {
                                       if let url = URL(string: "http://192.168.0.1"){
                                           openURL(url)
                                       }
                                   })
                                   {
                                       Text("조치#1 공용 와이파이 라우터 접속")
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
                                       Text("조치#2 gstatic")
                                           .padding()
                                           .frame(maxWidth: .infinity)
                                           .foregroundColor(Color.white)
                                           .background(Color.accentColor)
                                           .cornerRadius(8)
                                   }
                                   
                                   Button(action: {
                                       if let url = URL(string: "http://captive.apple.com/hotspot-detect.html"){
                                           openURL(url)
                                       }
                                   })
                                   {
                                       Text("조치#3 apple captive portal")
                                           .padding()
                                           .frame(maxWidth: .infinity)
                                           .foregroundColor(Color.white)
                                           .background(Color.accentColor)
                                           .cornerRadius(8)
                                   }
                                   
               
                
                               }
                               
                               Spacer().frame(minHeight: 30)
          
            Button(action: {
                if let url = URL(string: "https://developer.apple.com/news/?id=q78sq5rv"){
                    openURL(url)
                }
            })
            {
                Text("이 문제가 발생하는 이유(영문)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.accentColor)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            
            Button(action: {
                if let url = URL(string: "https://forms.gle/CiwkYGa2fhu4zuZFA"){
                    openURL(url)
                }
            })
            {
                Text("버그 신고 및 건의")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.accentColor)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            }.padding().navigationTitle("조치")
            
        
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
