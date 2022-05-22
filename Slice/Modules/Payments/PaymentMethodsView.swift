//
//  PaymentMethodsView.swift
//  Slice
//
//  Created by Artyom Batura on 22.05.22.
//

import Foundation
import SwiftUI

class PaymentMethodsViewModel: ObservableObject {
	let paymentService: PaymentsService = Service.Payments.shared
	
	var paymentMethods: [APIResults.CardAPI] = []
	
	@Published var cardViewModels: [CardStructure] = []
	
	init() { }
	
	func fetchPaymentMethods() {
		paymentService.fetchAllPaymentMethods { result in
			if case let .success(cards) = result {
				DispatchQueue.main.async {
					self.cardViewModels = cards.map({
						let linearColors = self.randomColorSet()
						return CardStructure(id: $0.id, cardNumber: $0.number,
									  cardProviderLogo: "visa_logo",
									  cardCurrency: "BY",
									  linearColor1: linearColors.0,
									  linearColor2: linearColors.1,
									  shadow: Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)))
					})
					self.paymentMethods = cards
				}
			}
		}
	}
	
	func randomColorSet() -> (Color, Color) {
		let range: ClosedRange<Double> = 0...255
		
		let first = Color(red: .random(in: range) / 255,
						  green: .random(in: range) / 255,
						  blue: .random(in: range) / 255,
						  opacity: 1.0)
		
		let second = Color(red: .random(in: range) / 255,
						  green: .random(in: range) / 255,
						  blue: .random(in: range) / 255,
						  opacity: 1.0)
		
		return (first, second)
	}

}

struct PaymentMethodsView: View {
	@State private var cardNumber: String = ""
	
	@State private var cardExpirationDate: String = ""
	
	@State private var cardCVC: String = ""
	
	@StateObject var viewModel = PaymentMethodsViewModel()
	
	@State private var isEditing: Bool = false
	
	var body: some View {

		ScrollView(.vertical, showsIndicators: false, content: {
			VStack(spacing: 30) {
				// MARK: - Scroll with all cards
				VStack(alignment: .leading) {
					if viewModel.cardViewModels.isNotEmpty {
						ScrollView(.horizontal, showsIndicators: false, content: {
							HStack(spacing: 16) {
								ForEach(viewModel.cardViewModels) { card in
									VStack {
										Card(id: card.id,
											 card: card,
											 isEditing: isEditing,
											 deleteAction: { idToRemove in
											viewModel.paymentService.deletePaymentMethod(id: idToRemove) { result in
												if case .success = result {
													self.viewModel.fetchPaymentMethods()
												}
											}
											withAnimation(.easeInOut, {
												self.isEditing.toggle()
											})
										})
											.frame(width: 320, height: 200)
											.rotationEffect(Angle(degrees: 90))
									}
								}
							}
							.frame(height: 375)
						})
					} else {
						Text("Список способов оплаты пуст")
							.font(.title)
					}
				}
				.padding(.top, 16)
				
				// MARK: - Adding info
				VStack(alignment: .leading, spacing: 16) {
					HStack {
					Text("Добавить новую карту:")
						.font(.system(size: 30,
									  weight: .bold,
									  design: .default))
					}
					
					VStack {
						TextField("Номер карты", text: $cardNumber)
							.font(.title2)
						
						RoundedRectangle(cornerRadius: 2)
							.frame(height: 2)
							.foregroundColor(.gray.opacity(0.4))
					}
					
					VStack {
					TextField("Срок истечения", text: $cardExpirationDate)
						.font(.title2)
						RoundedRectangle(cornerRadius: 2)
							.frame(height: 2)
							.foregroundColor(.gray.opacity(0.4))
					}
					
					VStack {
					TextField("CVC", text: $cardCVC)
						.font(.title2)
						RoundedRectangle(cornerRadius: 2)
							.frame(height: 2)
							.foregroundColor(.gray.opacity(0.4))
					}
					
					HStack {
						Spacer()
						
						Button(action: {
							guard cardNumber.count == 16,
								  cardExpirationDate.count == 4,
								  cardCVC.count == 3 else {
									  return
								  }
							viewModel.paymentService.addPaymentMethod(number: cardNumber,
																	  expiration: cardExpirationDate,
																	  cvc: cardCVC) { result in
								if case .success = result {
									cardNumber = ""
									cardExpirationDate = ""
									cardCVC = ""
									viewModel.fetchPaymentMethods()
								}
							}
						}, label: {
							RoundedRectangle(cornerRadius: 100)
								.shadow(radius: 10)
								.overlay(
									Text("Добавить")
										.foregroundColor(.white)
								)
						})
							.frame(height: 60)
						
						Spacer()
					}
					.padding(.top, 40)
				}
				.padding(.horizontal, 16)
				.padding(.top, 40)
			}
		})
			.navigationTitle("Мои карты:")
			.toolbar(content: {
				Button(action: {
					withAnimation(.easeInOut, {
						self.isEditing.toggle()
					})
				}, label: {
					Image(systemName: "pencil.circle")
				})
			})
			.onAppear {
				viewModel.fetchPaymentMethods()
			}
		
	}
}

struct Card: View {
	var id: Int
	var card: CardStructure
	var isEditing: Bool
	var deleteAction: (Int) -> Void
	
	var body: some View {
		HStack {
			VStack {
				HStack {
					Text("•••• •••• •••• \(String(card.cardNumber.suffix(4)))")
						.foregroundColor(Color(#colorLiteral(red: 0.8989498147, green: 0.7744829563, blue: 1, alpha: 1)))
					Spacer()
				}
				Spacer()
				HStack {
					Spacer()
					Image(card.cardProviderLogo)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50, height: 40)
						.padding(.trailing, 9)
				}
			}
			.background(LinearGradient(gradient: Gradient(colors: [card.linearColor1, card.linearColor2]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
			.cornerRadius(15)
			.shadow(color: card.shadow.opacity(0.5), radius: 10, x: 8, y: 12)
			
			Spacer()
			
			if isEditing {
				HStack {
					Spacer()
					
					Button {
						deleteAction(id)
					} label: {
						Image(systemName: "trash.slash.circle.fill")
							.resizable()
							.frame(width: 32, height: 32, alignment: .center)
							.tint(.red)
					}
					
					Spacer()
				}
				.frame(width: 32, height: 32, alignment: .center)
				.rotationEffect(Angle(degrees: -90))
			}
		}
	}
}

struct CardStructure: Identifiable {
	var id: Int
	var cardNumber: String
	var cardProviderLogo: String
	var cardCurrency: String
	var linearColor1: Color
	var linearColor2: Color
	var shadow: Color
}

struct ScrollingHStackModifier: ViewModifier {
	
	@State private var scrollOffset: CGFloat
	@State private var dragOffset: CGFloat
	
	var items: Int
	var itemWidth: CGFloat
	var itemSpacing: CGFloat
	
	init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
		self.items = items
		self.itemWidth = itemWidth
		self.itemSpacing = itemSpacing
		
		// Calculate Total Content Width
		let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
		let screenWidth = UIScreen.main.bounds.width
		
		// Set Initial Offset to first Item
		let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
		
		self._scrollOffset = State(initialValue: initialOffset)
		self._dragOffset = State(initialValue: 0)
	}
	
	func body(content: Content) -> some View {
		content
			.offset(x: scrollOffset + dragOffset, y: 0)
			.gesture(DragGesture()
				.onChanged({ event in
					self.dragOffset = event.translation.width
				})
				.onEnded({ event in
					// Scroll to where user dragged
					self.scrollOffset += event.translation.width
					self.dragOffset = 0
					
					// Now calculate which item to snap to
					let contentWidth: CGFloat = CGFloat(self.items) * self.itemWidth + CGFloat(self.items - 1) * self.itemSpacing
					let screenWidth = UIScreen.main.bounds.width
					
					// Center position of current offset
					let center = self.scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
					
					// Calculate which item we are closest to using the defined size
					var index = (center - (screenWidth / 2.0)) / (self.itemWidth + self.itemSpacing)
					
					// Should we stay at current index or are we closer to the next item...
					if index.remainder(dividingBy: 1) > 0.5 {
						index += 1
					} else {
						index = CGFloat(Int(index))
					}
					
					// Protect from scrolling out of bounds
					index = min(index, CGFloat(self.items) - 1)
					index = max(index, 0)
					
					// Set final offset (snapping to item)
					let newOffset = index * self.itemWidth + (index - 1) * self.itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - self.itemWidth) / 2.0) + self.itemSpacing
					
					// Animate snapping
					withAnimation {
						self.scrollOffset = newOffset
					}
					
				})
			)
	}
}
