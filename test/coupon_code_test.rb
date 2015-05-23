require 'test_helper'

describe LOLCouponCode do
  describe 'Generator' do
    def generate(*args)
      LOLCouponCode.generate(*args)
    end

    it 'should be loaded.' do
      LOLCouponCode.must_respond_to(:generate)
    end

    it 'should generate a code' do
      generate.wont_be_empty
    end

    it 'should only contain uppercase letters, digits, and dashes.' do
      generate.must_match(/^[0-9A-Z-]+$/)
    end

    # it 'should look like XXXX-XXXX-XXXX.' do
    #   generate.must_match(/^\w{4}-\w{4}-\w{4}$/)
    # end

    it 'should look like XXXXXXXX.' do
      generate.must_match(/^\w{4}\w{4}$/)
    end

    it 'should generate different codes.' do
      code1 = generate
      code2 = generate
      code1.wont_equal(code2)
    end

    it 'should generate an arbitrary number of parts.' do
      generate(parts: 2).must_match(/^\w{4}\w{4}$/)
      generate(parts: 5).must_match(/^\w{4}\w{4}\w{4}\w{4}\w{4}$/)
    end
  end

  describe 'Validator' do
    it 'should be loaded.' do
      LOLCouponCode.must_respond_to(:validate)
    end

    it 'should fail to validate invalid code.' do
      LOLCouponCode.validate('').must_equal(nil)
    end

    it 'should accept a valid code.' do
      LOLCouponCode.validate('DJQ6-DPMD').wont_be_nil
    end

    it 'should reject a short code.' do
      LOLCouponCode.validate('DJQ6-DPMD-DB6T').must_be_nil
    end

    it 'should accept a short code with correct parts.' do
      LOLCouponCode.validate('DJQ6-DPMD', 2).wont_be_nil
    end

    it 'should reject a short code with wrong parts.' do
      LOLCouponCode.validate('DJQ8-DPM3', 2).must_be_nil
    end

    it 'should fix and validate a lowercase code.' do
      code = 'djq6dpmd'
      LOLCouponCode.validate(code.downcase).must_equal(code.upcase)
    end

    it 'should validate alternative separators.' do
      code = 'djq6/dpmd/db6t'
      LOLCouponCode.validate(code,3).must_equal('DJQ6DPMDDB6T')

      code = 'djq6 dpmd db6t'
      LOLCouponCode.validate(code,3).must_equal('DJQ6DPMDDB6T')

      code = 'djq6dpmddb6t'
      LOLCouponCode.validate(code,3).must_equal('DJQ6DPMDDB6T')
    end

    it 'should valid code-pretest.' do
      LOLCouponCode.validate('C9X7', 1).wont_be_nil
      LOLCouponCode.validate('C9X8', 1).must_be_nil

      LOLCouponCode.validate('C9X7-RJ6K', 2).wont_be_nil
      LOLCouponCode.validate('C9X7-RJ62', 2).must_be_nil

      LOLCouponCode.validate('C9X7-RJ6K-6FXH', 3).wont_be_nil
      LOLCouponCode.validate('C9X7-RJ6K-6FX1', 3).must_be_nil

      LOLCouponCode.validate('C9X7-RJ6K-6FXH-YH5B', 4).wont_be_nil
      LOLCouponCode.validate('C9X7-RJ6K-6FXH-YH52', 4).must_be_nil

      LOLCouponCode.validate('C9X7-RJ6K-6FXH-YH5B-UF8V', 5).wont_be_nil
      LOLCouponCode.validate('C9X7-RJ6K-6FXH-YH5B-UF8X', 5).must_be_nil

      LOLCouponCode.validate('C9X7-RJ6K-6FXH-YH5B-UF8V-4TQJ', 6).wont_be_nil
      LOLCouponCode.validate('C9X7-RJ6K-6FXH-YH5B-UF8V-4TQ1', 6).must_be_nil
    end

    it 'bulk generate should always be valid' do
      500.times do |i|
        code = LOLCouponCode.generate()
        LOLCouponCode.validate(code).wont_be_nil
      end
      500.times do |i|
        code = LOLCouponCode.generate(parts: 4)
        LOLCouponCode.validate(code, 4).wont_be_nil
      end
    end



  end
end