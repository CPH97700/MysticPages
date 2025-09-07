//
//  Extensions.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//





import Foundation
import SwiftUI

extension View {
    
   
    func maxWidth() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func maxHeight() -> some View {
        self.frame(maxHeight: .infinity)
    }
    
    func maximize() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

   
    func appBackground() -> some View {
        self.background(LinearGradient.appBackground.ignoresSafeArea())
    }

    
    func appButtonStyle() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .tint(DesignSystem.Colors.icons)
            .foregroundStyle(.white)
    }
    
    func primaryActionButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(DesignSystem.Colors.buttons)
            .foregroundColor(.white)
            .font(DesignSystem.Fonts.headline)
            .cornerRadius(12)
            .shadow(color: DesignSystem.Colors.buttons.opacity(0.3), radius: 6, x: 0, y: 4)
    }
    
    func plainActionButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(DesignSystem.Colors.buttons)
            .font(DesignSystem.Fonts.subheadline)
    }
    
    func libraryButtonStyle() -> some View {
        self
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(DesignSystem.Colors.section.opacity(0.8))
            .foregroundColor(DesignSystem.Colors.icons)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    func toReadButtonStyle() -> some View {
        self
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(DesignSystem.Colors.section.opacity(0.8))
            .foregroundColor(DesignSystem.Colors.icons)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .bold()
    }
    
    
    func textStyleTitle() -> some View {
        self
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .foregroundColor(.primary)
    }
    
    func textStyleAuthor() -> some View {
        self
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(DesignSystem.Colors.icons)
    }
    
    func toReadTitlestyle() -> some View {
        self
            .font(DesignSystem.Fonts.headline)
            .foregroundColor(DesignSystem.Colors.icons)
            .padding(.horizontal)
    }

    func myLibraryViewStyle() -> some View {
        self
            .font(DesignSystem.Fonts.headline)
            .foregroundColor(.black)
            .padding(.horizontal)
    }

    
   
    
    func customTextFieldStyle() -> some View {
        self
            .textFieldStyle(.roundedBorder)
            .font(DesignSystem.Fonts.body)
            .padding(.vertical, 6)
    }
    
    func noteTextEditorStyle() -> some View {
        self
            .frame(height: 100)
            .font(DesignSystem.Fonts.body)
            .padding(8)
            .background(DesignSystem.Colors.elements.opacity(0.2))
            .cornerRadius(12)
    }

    
    func bookCardFrontStyle() -> some View {
        self
            .padding()
            .background(DesignSystem.Colors.section)
            .cornerRadius(30)
    }
    
    func bookCardContainerStyle() -> some View {
        self
            .frame(width: 230, height: 330)
            .background(DesignSystem.Colors.background)
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
    }

    func sectionCardStyle() -> some View {
        self
            .padding()
            .background(DesignSystem.Colors.section)
            .cornerRadius(DesignSystem.cornerRadius)
            .shadow(color: DesignSystem.cardShadow, radius: DesignSystem.shadowRadius, x: 0, y: 4)
    }

    
    func sectionHeaderStyle() -> some View {
        self
            .font(DesignSystem.Fonts.sectionHeader)
            .foregroundColor(DesignSystem.Colors.icons)
    }
    func genreButtonContainerStyle(isSelected: Bool) -> some View {
          self
              .padding()
              .background(isSelected ? Color.purple : Color.gray.opacity(0.2))
              .cornerRadius(DesignSystem.cornerRadius)
              .shadow(color: isSelected ? .purple.opacity(0.3) : .clear, radius: 6)
      }
      
      func genreButtonLabelStyle(isSelected: Bool) -> some View {
          self
              .font(.title2.bold())
              .foregroundStyle(isSelected ? .white : .purple)
      }
      
   

    
        func homeTitleStyle() -> some View {
            self
                .font(.largeTitle.bold())
                .foregroundColor(Color.black.opacity(0.6))
                .padding(.top)
        }
  
        func bookSpineStyle(gradient: LinearGradient) -> some View {
            self
                .frame(width: 24, height: 120)
                .background(gradient)
                .cornerRadius(DesignSystem.cornerRadius / 2)
                .shadow(color: DesignSystem.cardShadow, radius: 4, x: 0, y: 2)
        }
        

        func spineTextStyle() -> some View {
            self
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .rotationEffect(.degrees(-90))
                .frame(width: 120, height: 24)
        }
        
     
        
   
        func shelfHeaderStyle() -> some View {
            self
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(.primary)
                .padding(.leading)
        }
        
   
        func shelfAddButtonStyle() -> some View {
            self
                .font(.title2)
                .foregroundColor(DesignSystem.Colors.icons)
                .padding(.trailing)
        }
        
        
        func shelfEmptyTextStyle() -> some View {
            self
                .font(DesignSystem.Fonts.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
    func quoteBubbleStyle() -> some View {
           self
               .padding()
               .background(DesignSystem.Colors.quotes.opacity(0.15))
               .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius * 1.5, style: .continuous))
               .shadow(color: DesignSystem.cardShadow.opacity(0.2), radius: 6, x: 0, y: 3)
       }

       func quoteTitleStyle() -> some View {
           self
               .font(DesignSystem.Fonts.sectionHeader)
               .foregroundColor(DesignSystem.Colors.icons)
       }

       func quoteContentStyle() -> some View {
           self
               .font(.system(size: 20, weight: .medium, design: .serif))
               .italic()
               .foregroundColor(.primary)
       }

       func quoteAuthorStyle() -> some View {
           self
               .font(DesignSystem.Fonts.subheadline)
               .foregroundColor(.secondary)
       }
    func settingsDestructiveButton() -> some View {
            self
                .font(DesignSystem.Fonts.body)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(DesignSystem.Colors.section.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    func dsCardStyle() -> some View {
           self
               .padding()
               .background(DesignSystem.Colors.section)
               .cornerRadius(DesignSystem.cornerRadius)
               .shadow(color: DesignSystem.cardShadow, radius: DesignSystem.shadowRadius, x: 0, y: 4)
       }

              func dsBackground() -> some View {
           self
               .background(LinearGradient.appBackground.ignoresSafeArea())
       }
       
 
       func dsPlaceholderImage(height: CGFloat = 180) -> some View {
           Rectangle()
               .fill(Color.gray.opacity(0.2))
               .frame(height: height)
               .overlay(
                   Text("Kein Bild")
                       .font(DesignSystem.Fonts.subheadline)
                       .foregroundColor(DesignSystem.Colors.icons)
               )
               .cornerRadius(12)
       }
   
        func dsTitleText() -> some View {
            self
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(DesignSystem.Colors.elements)
                .multilineTextAlignment(.center)
        }

        func dsSubtitleText() -> some View {
            self
                .font(DesignSystem.Fonts.subheadline)
                .foregroundColor(DesignSystem.Colors.icons)
                .multilineTextAlignment(.center)
        }

        func dsEmptyStateText() -> some View {
            self
                .font(DesignSystem.Fonts.subheadline)
                .foregroundColor(DesignSystem.Colors.icons)
                .padding()
                .background(DesignSystem.Colors.section)
                .cornerRadius(12)
        }

        func dsSectionHeader() -> some View {
            self
                .font(DesignSystem.Fonts.sectionHeader)
                .foregroundColor(DesignSystem.Colors.elements)
        }
   

        func appTextfieldStyle() -> some View {
            self
                .maxWidth()
                .padding()
                .background(Color.white.opacity(0.15)) // Hellerer Hintergrund
                .foregroundColor(.white) // Sichtbarer Text
                .placeholderStyle()
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }

        func placeholderStyle() -> some View {
            self
                .accentColor(.white)
                .font(.body)
        }
    }

    

   
    
   
    


  
