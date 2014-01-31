class Cart < AttributeInitializable
  def self.clear
    @@browser.execute_script("InstacartStore.cart.clear()")
  end

  def self.place_order
    # Open cart dropdown and click checkout button.
    @@browser.div(:id => "cart-in-nav").click
    @@browser.a(:class => "btn-checkout").click

    # Delivery page. Use the defaults.
    puts "Filling out delivery page..."
    @@browser.textarea(:id, "order_special_instructions").when_present(5).set("Please leave groceries at the door if no one is home. Thanks!")
    @@browser.element(:xpath, "//div[@id='delivery-options-1']/div/li/span").when_present(5).click
    @@browser.li({:class => "delivery-option", :text => /7-8pm/}).click
    @@browser.button(:value, /Next/).when_present(5).click

    # Payment page. Use default credit card, add a $2 tip.
    puts "Filling out payment page..."
    @@browser.element(:data_tip_amount, '2').when_present(5).click
    Watir::Wait.until { @@browser.button(:value, /Next/).when_present(5).enabled? }
    @@browser.button(:value, /Next/).click

    # Replacements page. Leave the default replacements and place the order!
    puts "Submitting final confirmation..."
    @@browser.button(:value, /Place Order/).when_present(5).click
  end
end
