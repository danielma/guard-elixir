require 'guard/compat/test/helper'
require 'guard/compat/plugin'
require 'guard/elixir'

RSpec.describe Guard::Elixir do
  before(:each) do
    @subject = Guard::Elixir.new
    @paths   = ['foo.ex', 'dir1/dir2/dir3/bar.ex']
  end

  describe 'initialize' do
    it 'should start with default options' do
      expect(@subject.options[:all_on_start]).to be true
      expect(@subject.options[:dry_run]).to be false
    end

    it 'should be possible to overwrite the default options' do
      @subject = Guard::Elixir.new(all_on_start: false, dry_run: true)

      expect(@subject.options[:all_on_start]).to be false
      expect(@subject.options[:dry_run]).to be true
    end
  end

  describe :start do
    describe :all_on_start do
      it 'should run all tests if all_on_start is true' do
        @subject = Guard::Elixir.new(dry_run: true)
        expect(@subject).to receive(:run_all)
        @subject.start
      end
      it 'should not run all tests on start if all_on_start is false' do
        @subject = Guard::Elixir.new(all_on_start: false, dry_run: true)
        expect(@subject).not_to receive(:run_all)
        @subject.start
      end
    end
  end

  describe :run_on_change do
    describe :dry_run do
      it 'should not perform a conversion on a dry run' do
        @subject = Guard::Elixir.new(dry_run: true)
        expect(Kernel).not_to receive(:exec)
        expect(Guard::UI).to receive(:info).exactly(@paths.count).times
        @subject.run_on_change(@paths)
      end
    end
  end

  describe :run_all do
    it 'should call run_on_change for all matching paths' do
      allow(Guard::Compat).to receive(:matching_files)
      @subject = Guard::Elixir.new(dry_run: true)
      expect(Dir).to receive(:glob).with('**/*.*')#.and_return(@paths)

      expect(Guard::Compat).to receive(:matching_files)#.with(@subject, @paths)

      expect(@subject).to receive(:run_on_change)#.with(@paths)
      @subject.run_all
    end
  end
end
