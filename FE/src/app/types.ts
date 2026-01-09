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

export interface PasswordPair {
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
  id: number;
  name: string;
  code: string;
  abbreviation: string;
  studyProgramName: string;
  recommendedYear: number;
  semester: string;
  obligation?: string;
}

export interface SubjectExtendedDto extends SubjectDto {
  focusDTO: FocusDto;
}

export interface GradeAverageByYearDto {
  year: number;
  averageGrade: number;
  studentCount: number;
}

export interface StudyProgramSubject {
  id: number;
  subject: SubjectDto;
  studyProgram: StudyProgramDto;
  recommendedYear: number;
  semester: string;
  obligation: string;
}

export interface SubjectWithCountDto {
  studyProgramSubject: StudyProgramSubject;
  studentCount: number;
}

export interface PopularSubjectRow {
  id: number;
  name: string;
  code: string;
  abbreviation: string;
  studyProgramName: string;
  obligation: string;
  recommendedYear: number;
  semester: string;
  studentCount: number;
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
  questionOption: string; // The label to be displayed
  questionValue: string; // The value to be sent to the backend
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

export enum StudyPrograms {
  Informatika = 3,
  Manažment = 4,
}

export interface KeywordDTO {
  keyword: string;
  count: number;
}

export interface FocusCategorySumDTO {
  focusCategory: string;
  totalSum: number;
}

export interface StudentYearCountDTO {
  year: number;
  studentsCount: number;
}

export interface StudentFilterDTO {
  studyProgramId?: number;
  year?: number;
  page: number;
  size: number;
  sortBy: string;
  direction: 'ASC' | 'DESC';
}

export interface StudentAverageGradeDTO {
  id: number;
  avgMark: number;
  year: number;
  studyProgramId: number;
}

export interface PageResponseDTO<T> {
  content: T[];
  pageable: {
    pageNumber: number;
    pageSize: number;
    sort: {
      sorted: boolean;
      unsorted: boolean;
      empty: boolean;
    };
    offset: number;
    paged: boolean;
    unpaged: boolean;
  };
  totalPages: number;
  totalElements: number;
  last: boolean;
  size: number;
  number: number;
  sort: {
    sorted: boolean;
    unsorted: boolean;
    empty: boolean;
  };
  numberOfElements: number;
  first: boolean;
  empty: boolean;
}

export type StudentAverageGradePageResponse =
  PageResponseDTO<StudentAverageGradeDTO>;

export interface DataReportDto {
  studentCount: number;
  subjectCount: number;
  studyProgramCount: number;
  studentTrend: StudentTrendDataPoint[];
  studentsPerYear: StudentsPerYear[];
  averageGradeByYear: AverageGradeDataPoint[];
  gradeDistribution: GradeDistribution[];
}

export interface StudentsPerYear {
  year: number;
  count: number;
}

export interface StudentTrendDataPoint {
  year: number;
  programCounts: StudyProgramCount;
}

export type StudyProgramId = 3 | 4;

export type StudyProgramCount = {
  [K in StudyProgramId]: number;
};

export interface AverageGradeDataPoint {
  academicYear: number; // e.g., 2019, 2020, 2021...
  year1: number; // Average grade for 1st year students
  year2: number; // Average grade for 2nd year students
  year3: number; // Average grade for 3rd year students
  year4: number; // Average grade for 4th year students
  year5: number; // Average grade for 5th year students
}

export interface GradeDistribution {
  grade: string; // A, B, C, D, E, FX
  count: number;
}

// Flattened interface for table display
export interface PopularSubjectRow {
  id: number;
  name: string;
  code: string;
  abbreviation: string;
  studyProgramName: string;
  obligation: string;
  recommendedYear: number;
  semester: string;
  studentCount: number;
}

export interface AppConfig {
  API_URL: string;
  ENVIRONMENT: string;
}

export type UserState = {
  userData: UserDto | undefined;
  userId: number | undefined;
  isLoading: boolean;
};
