class Cart < AttributeInitializable
  def self.clear
    @@browser.execute_script("InstacartStore.cart.clear()")
  end

  def self.place_order
    # Open cart dropdown and click checkout button.
    @@browser.div(:id => "cart-in-nav").click
    @@browser.a(:class => "btn-checkout").click

    # Delivery page. Use the defaults.
    # TODO: Add delivery instructions.
    # TODO: Set delivery time.
    @@browser.button(:value, /Next/).when_present(5).click

    # Payment page. Use default credit card, add a $2 tip.
    @@browser.element(:data_tip_amount, '2').when_present(5).click
    Watir::Wait.until { @@browser.button(:value, /Next/).enabled? }
    @@browser.button(:value, /Next/).click

    # Replacements page. Leave the default replacements and place the order!
    @@browser.button(:value, /Place Order/).wait_until_present 5

    # (Except don't actually place the order for now. Just take a screenshot to show we got this far.)
    @@browser.screenshot.save("/var/screenshots/place-order.png")
    #@@browser.button(:value, /Place Order/).click
  end
end
