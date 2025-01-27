import {
  ApexAxisChartSeries,
  ApexChart,
  ApexDataLabels,
  ApexPlotOptions,
  ApexResponsive,
  ApexTitleSubtitle,
  ApexXAxis,
} from 'ng-apexcharts';
import { AuthRole } from '@enums/auth-role';

export interface Role {
  id: number;
  name: string;
}

export interface RegisterUserDto {
  firstName: string;
  lastName: string;
  rolesIds: number[];
  email: string;
  password: string;
}

export interface UserDto {
  userId: number;
  firstName: string;
  lastName: string;
  roles: Role[];
  email: string;
}

export interface LoginUserDto {
  email: string;
  password: string;
}

export interface ChangePasswordDto {
  email: string;
  oldPassword: string;
  newPassword: string;
}

export interface AuthResponseDto {
  jwtToken: string;
  expiresIn: number;
  userRoles: AuthRole[];
}

export interface FocusDto {
  mathFocus: number;
  logicFocus: number;
  programmingFocus: number;
  designFocus: number;
  economicsFocus: number;
  managementFocus: number;
  hardwareFocus: number;
  networkFocus: number;
  dataFocus: number;
  testingFocus: number;
  languageFocus: number;
  physicalFocus: number;
}

export interface SubjectDto {
  name: string;
  code: string;
  abbreviation: string;
  studyProgramName: string;
  recommendedYear: number;
  semester: string;
}

export interface SubjectExtendedDto extends SubjectDto {
  focusDTO: FocusDto;
}

export interface StudyProgramDto {
  id: number;
  name: string;
}

export interface TeacherDto {
  teacherId: number;
  userId: number;
  department: DepartmentDto;
  subjects: SubjectDto[];
}

export interface DepartmentDto {
  id: number;
  name: string;
  abbreviation: string;
}

export interface Page<T> {
  content: T[];
  pageable: {
    sort: {
      sorted: boolean;
      unsorted: boolean;
      empty: boolean;
    };
    offset: number;
    pageNumber: number;
    pageSize: number;
    paged: boolean;
    unpaged: boolean;
  };
  last: boolean;
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  sort: {
    sorted: boolean;
    unsorted: boolean;
    empty: boolean;
  };
  first: boolean;
  numberOfElements: number;
  empty: boolean;
}

// Questionnaire types
export interface Option {
  questionOption: string;
}

export interface Question {
  id: number;
  questionTitle: string;
  answerType: 'TEXT' | 'NUMERIC' | 'RADIO' | 'CHECKBOX' | 'DROPDOWN' | 'GRADE';
  optional: boolean;
  questionIdentifier: string;
  positionInQuestionnaire: number;
  options: Option[];
}

export interface AnsweredQuestion {
  id: number;
  questionTitle: string;
  answerType: 'TEXT' | 'NUMERIC' | 'RADIO' | 'CHECKBOX' | 'DROPDOWN' | 'GRADE';
  optional: boolean;
  questionIdentifier: string;
  positionInQuestionnaire: number;
  options: Option[];
  answers: Answer[];
}

export interface Section {
  sectionTitle: string;
  sectionDescription: string;
  questions: Question[];
}

export interface AnsweredSection {
  sectionTitle: string;
  sectionDescription: string;
  questions: AnsweredQuestion[];
}

export interface AnsweredForm {
  id: number;
  title: string;
  description: string;
  dateOfCreation: string;
  sections: AnsweredSection[];
}

export interface Form {
  id: number;
  title: string;
  description: string;
  dateOfCreation: string;
  sections: Section[];
}

export interface AnswerText {
  textOfAnswer: string;
}

export interface Answer {
  questionId: number;
  texts: AnswerText[];
}

export interface UserFormAnswers {
  formId: number;
  answers: Answer[];
}

export interface SubjectGradesDto {
  subject: SubjectDto;
  studentsCount: number;
  gradeA: number;
  gradeB: number;
  gradeC: number;
  gradeD: number;
  gradeE: number;
  gradeFx: number;
  gradeAverage: number;
}

export interface SubjectPassingPrediction {
  subjectName: string;
  passingProbability: number;
  mark: string;
  recommendations?: string[];
}

export interface SubjectGradeCorrelation {
  firstSubject: SubjectDto;
  secondSubject: SubjectDto;
  correlation: number;
}

export interface ApexChartOptions {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  dataLabels: ApexDataLabels;
  title: ApexTitleSubtitle;
  colors: string[];
  plotOptions: ApexPlotOptions;
  xAxis: ApexXAxis;
  responsive: ApexResponsive[];
}

export interface KeywordDto {
  keyword: string;
  subjects: SubjectDto[];
}
