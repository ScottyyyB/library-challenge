require './lib/library.rb'
require './lib/person.rb'

describe Library do
  let (:person) { instance_double('Person', name: 'Scott', my_books: [])}

  before do
    allow(person).to receive(:library).and_return(Library.new)
    allow(person).to receive(:library=)
    allow(person).to receive(:my_books=)
  end

  it 'has collection of books on initialize' do
    expect(subject.books).to eq [{:item=>{:title=>"Diary of a Wimpy Kid", :author=>"Jeff Kinney"}, :available=>true, :return_date=>nil},
 {:item=>{:title=>"Harry Potter and the Chamber of Secrets", :author=>"J.K. Rowling"}, :available=>true, :return_date=>nil},
 {:item=>{:title=>"The Hunger Games", :author=>"Suzanne Collins"}, :available=>true, :return_date=>nil},
 {:item=>{:title=>"The Lord Of The Rings", :author=>"J.R.R Tolkien"}, :available=>true, :return_date=>nil},
 {:item=>{:title=>"Of Mice And Men", :author=>"John Steinbeck"}, :available=>true, :return_date=>nil}]
  end
    describe '#search' do
      it 'is expected to find book when searched by title only' do
        expected_output = [{:item=>
          {:title=>"The Hunger Games", :author=>"Suzanne Collins"},
          :available=>true, :return_date=>nil}]
        expect(subject.search(title: "The Hunger Games")).to eq expected_output
      end

      it 'is expected to find book when searched by author only' do
        expected_output = [{:item=>
          {:title=>"The Lord Of The Rings", :author=>"J.R.R Tolkien"},
          :available=>true, :return_date=>nil}]
        expect(subject.search(author: "J.R")).to eq expected_output
      end

      it 'is expected to find book when searched by title and author' do
        expected_output = [{:item=>
          {:title=>"The Hunger Games", :author=>"Suzanne Collins"},
          :available=>true, :return_date=>nil}]
          expect(subject.search(title: "The", author: "Suz")).to eq expected_output
      end

      it 'is expected to find book when searched by available' do
        expected_output = [{:item=>
          {:title=>"Diary of a Wimpy Kid", :author=>"Jeff Kinney"},
          :available=>true, :return_date=>nil},
 {:item=>
   {:title=>"Harry Potter and the Chamber of Secrets", :author=>"J.K. Rowling"},
   :available=>true, :return_date=>nil},
 {:item=>
   {:title=>"The Hunger Games", :author=>"Suzanne Collins"},
   :available=>true, :return_date=>nil},
 {:item=>{:title=>"The Lord Of The Rings", :author=>"J.R.R Tolkien"},
 :available=>true, :return_date=>nil},
 {:item=>
   {:title=>"Of Mice And Men", :author=>"John Steinbeck"},
   :available=>true, :return_date=>nil}]
        expect(subject.search(available: true)).to eq expected_output
      end
    end

    describe '#checkout' do

      before do
        subject.checkout("The Hunger Games", person)
      end
      it 'is expected to add book to person\'s my books and to not let person checkout again' do
        expect(subject.checkout("The Lord Of The Rings", person)).to eq "You still need to return The Hunger Games"
        expect(person.my_books).to eq [{:item=>
          {:title=>"The Hunger Games", :author=>"Suzanne Collins"},
          :return_date=>"2017-12-06"}]
      end

      it 'is expected to modify book\'s available to false on checkout' do
        expect(subject.books[2][:available]).to eq false
      end

      it 'is expected to modify book\'s return date on checkout' do
        expect(subject.books[2][:return_date]).to eq "2017-12-06"
      end

      it 'is expected to now allow checkout of unavailable book' do
        expect(subject.checkout("The Hunger Games", person)).to eq "The Hunger Games is currently not available"
      end
    end

      describe '#return' do
      it "is to receive message You have no books to return" do
        expect(subject.return(person)).to eq "You have no books to return"
      end
    end
  end
