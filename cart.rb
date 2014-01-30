class Cart < AttributeInitializable
  def self.clear
    @@browser.execute_script("InstacartStore.cart.clear()")
  end

  def self.place_order
    @@browser.div(:id => "cart-in-nav").click
    @@browser.a(:class => "btn-checkout").click

    sleep 1

    # Deliver between 6 and 7 pm.
    #@@browser.select_list(:id, "delivery_option_1").select_value("6-7pm")

    # Submit order.
    puts @@browser.url, @@browser.title
    @@browser.button(:value, /Next/).click
    sleep 2
    puts @@browser.url, @@browser.title
    @@browser.element(:data_tip_amount, '2').click
    puts @@browser.url, @@browser.title
    @@browser.button(:value, /Next/).click
    puts @@browser.url, @@browser.title
    @@browser.button(:value, /Place Order/).click
  end
end
