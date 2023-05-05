# frozen_string_literal: true
require  'minitest/autorun'
require 'json'
require_relative '../../Lab2/udentXD/lib/Student'

class StudentTest < Minitest::Test
  def setup
    @student = Student.new(
      'Лукашев',
      'Алексей',
      'Андреевич',
      id: 10,
      phone: '89099997499',
      telegram: '@lehadrilla',
      email: 'leha@gmail.com',
      git: '@netuOnNeftyanik'
    )
  end

  def teardown
    # Do nothing
  end

  def test_student_init_all_params_correct
    assert @student.last_name == 'Лукашев'
    assert @student.first_name == 'Алексей'
    assert @student.parental_name == 'Андреевич'
    assert @student.id == 10
    assert @student.phone == '89099997499'
    assert @student.telegram == '@lehadrilla'
    assert @student.email == 'leha@gmail.com'
    assert @student.git == '@netuOnNeftyanik'
  end

  def test_student_empty_options
    Student.new('Сергеев', 'Сергей', 'Сергеевич')
  end

  def test_student_short_contact
    short_contact = @student.get_short_contact


    assert short_contact[:type] == :telegram
    assert short_contact[:val] == '@lehadrilla'
  end

  def test_student_has_contacts
    assert @student.valid_cont? == true
  end

  def test_student_set_contacts
    stud = Student.new('Орфов', 'Орф', 'Орфович')
    stud.set_contacts(phone: '89097768999', telegram: '@kasha', email: 'kasha@gmail.com')

    assert stud.phone == '89097768999'
    assert stud.telegram == '@kasha'
    assert stud.email == 'kasha@gmail.com'
  end

  def test_student_get_short_fio
    assert @student.get_short_fio == 'fio:Лукашев А. А.'
  end


  def test_student_from_and_to_hash
    test_hash = {
      last_name: 'Жанов',
      first_name: 'Жан',
      parental_name: 'Жанович',
      id: 5,
      phone: '87776665544',
      telegram: '@abv',
      email: 'abv@mail.ru',
      git: '@abvG'
    }


    stud = Student.from_hash(test_hash)

    assert stud.last_name == 'Жанов'
    assert stud.first_name == 'Жан'
    assert stud.parental_name == 'Жанович'
    assert stud.id == 5
    assert stud.phone == '87776665544'
    assert stud.telegram == '@abv'
    assert stud.email == 'abv@mail.ru'
    assert stud.git == '@abvG'

    assert stud.to_hash == test_hash
  end
end
