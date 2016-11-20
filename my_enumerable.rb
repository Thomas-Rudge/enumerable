module Enumerable
  def my_each
    for item in self do
      yield item
    end
  end
  
  def my_each_with_index
    for item in self do
      yield self.index(item), item
    end
  end
  
  def my_select
    result = Array.new
    
    for item in self do
      meets_condition = yield item
      result << item if meets_condition
    end
    
    return result
  end
  
  def my_all?
    result = true
    
    for item in self do
      result = block_given? ? (yield item) : !(item.nil? || item == false)
      break if !result
    end
    
    return result
  end
  
  def my_any?
    result = false
    
    for item in self do
      result = block_given? ? (yield item) : !(item.nil? || item == false)
      break if result
    end
    
    return result
  end
  
  def my_none?
    block_given? ? !self.my_any? { |item| yield item } : !self.my_any?
  end
  
  def my_count(*args)
    count = 0
    args = args.empty? ? nil : args[0]
    
    for item in self do
      if args
        item == args ? count += 1 : next
      elsif block_given?
        (yield item) ? count += 1 : next
      else
        count += 1
      end
    end
    
    return count
  end
  
  def my_map
    !block_given? ? (return self.to_enum) : nil
    
    result = Array.new
    
    for item in self do
      result << (yield item)
    end
    
    return result
  end
  
  def my_inject(*args)
    (args.empty? && !block_given?) ? (return "Error, called without argument or block") : nil
    
    memo = (!args.empty? && (args[0].is_a? Integer)) ? args[0] : nil
    operator = (!args.empty? && (args[-1].is_a? Symbol)) ? args[-1] : nil
    
    for item in self do
      if !memo 
        memo = item
        next
      end
      if operator
        memo = memo.method(operator)
        memo = memo.call(item)
      elsif block_given?
        memo = yield memo, item
      end
    end
    
    return memo
    
  end
  
  alias_method :my_collect, :my_map 
  alias_method :my_reduce, :my_inject
end
