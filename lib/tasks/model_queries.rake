namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 1: First query; Show the amount of tickets a given Customer has bought (id = 2)")
    result = Customer.find(2).tickets.count
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("Query 2: Report the total number of different events that a given customer has attended.")
    result = Event.joins(ticket_types: { tickets: :order }).where(orders: {customer_id: 2}).select(:name).distinct.count
    puts(result)
    puts("EOQ")
    puts("Query 3: Third query; Report the total number of different events that a given customer has attended. (id = 2)")
    resul = Event.joins(ticket_types:{tickets: :order}).where(orders:{customer_id:2}).select(:name).distinct.map {|x| x.name}
    puts(resul)
    puts("EOQ")
    puts("Query 4: Total number of tickets sold for an event.")
    results = Ticket.joins(ticket_type: :event).where(events: {id: 2}).count
    puts(results)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("Query 5: Fifht query; The total sales of an event. (id = 1)")
    resu = TicketType.joins(:tickets, :event).where(event: 1). select("ticket_types.ticket_price"). sum("ticket_price")
    puts(resu)
    puts("EOQ")
    puts("Query 6: The event that has been most attended by women.")
    re = Event.order(created_at: :asc).joins(ticket_types: { tickets: { order: :customer } }).where(customers: { gender: 'f' }).group(:name).count.first
    puts(re)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("Query 7: Fifht query;  The event that has been most attended by men ages 18 to 30.")
    res = Event.order(created_at: :asc).joins(ticket_types: { tickets: { order: :customer } }). where("customers.gender = 'm' and\ customers.age >18 and customers.age <=30").group(:name).count.first
    puts(res)
    puts("EOQ")
  end
end