% Assurez vous d'avoir installe tous les paquets utiles
%%%%%% Licence Creative Commons-Paternité-Partage des Conditions Initale à l'identique%%%%%%%%%%%%%%%%%%%%%
% Auteur : Maïeul Rouquette
% http://creativecommons.org/licenses/by-sa/2.0/fr/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{facture}[6/09/2011 v1.0]
\LoadClass{article}
\RequirePackage{fontspec}	
\RequirePackage{xunicode}
\RequirePackage{polyglossia}
\setmainlanguage{french}
\RequirePackage{fltpoint}% Pour faire les calculs dans le tableau
\RequirePackage{tikz} % tikz est utilise pour tracer des boites, par exemple
\RequirePackage{graphicx} % Pour insérer des images. Utiliser le format jpg pour plus de simplicité.
\RequirePackage{fancyhdr} % Pour entête et pied de page
\RequirePackage{pifont} % Pour utiliser des symboles divers.
\RequirePackage[paper=a4paper,top=2 cm, bottom=2 cm, left=1.5 cm, right=2.5 cm]{geometry} % On peut modifier ces valeurs pour augmenter ou réduire les marges. 
\RequirePackage{ifthen}
\RequirePackage{array}
\RequirePackage{longtable}
\RequirePackage{advdate}
\RequirePackage{etoolbox}
\RequirePackage{xargs}


%%%%%%%%%%%%%%%% COULEURS
\definecolor{entetes}{HTML}{888888}
\definecolor{encadre}{RGB}{111,111,111}
\definecolor{blanc}{RGB}{255,255,255}

%%%%%%%%%%%%%%% Chaînes de langues

% Entête
\newcommand{\codeclient}{Code client :}
\newcommand{\datetxt}{Date:}
\newcommand{\datelimitetxt}{À payer avant:}
\newcommand{\facturation}{Facturation}
\newcommand{\facturetxt}{Facture}
\newcommand{\livraison}{Livraison}
\newcommand{\livraisonfacturation}{Livraison et Facturation}
\newcommand{\ntxt}{~n°}

% Facture

\newcommand{\produit}{Produit}
\newcommand{\prixHT}{Prix HT}
\newcommand{\quantite}{Quantité}
\newcommand{\remise}{Remise}
\newcommand{\TVAtxt}{TVA}
\newcommand{\prixTTC}{Prix TTC}
\newcommand{\totalHT}{Total HT}
\newcommand{\unite}{€}
\newcommand{\totHTtxt}{Total HT}
\newcommand{\totTVAtxt}{Total TVA}
\newcommand{\totTTCtxt}{Total TTC}
%%%%%%%%%%%%% Variable mathématiques

\newcommand{\tvadefaut}{19,6}
\newcommand{\arrondi}{-1}

%%%%%%%%%%% Méta-données %%%%%%%%%%%


% Valeurs par défaut
\gdef\@type{\facturetxt}

\newcommand{\datelimite}[1]{\newcommand{\@datelimite}{#1}}
\newcommand{\dest}[1]{\newcommand{\@dest}{#1}}
\newcommand{\fact}[1]{\newcommand{\@fact}{#1}}
\newcommand{\adresseemet}[1]{\gdef\@adresseemet{#1}}
\newcommand{\nomemet}[1]{\gdef\@nomemet{#1}}
\newcommand{\type}[1]{\gdef\@type{#1}}
\newcommand{\numero}[1]{\gdef\@numero{#1}}
\newcommand{\codedest}[1]{\gdef\@codedest{#1}}
\newcommand{\pied}[1]{\rfoot{#1}}
\setlength{\tabcolsep}{1pt}

%%%%%%%%%% Entete
\newcommand{\entete}{
	
	
	\noindent\begin{tikzpicture}
	
		\noindent\node [font=\bf\Huge,text width=0.5\textwidth,text=entetes,text centered]{%		
			\@nomemet%
		};
			
		\noindent\node (b)[xshift=0.5\textwidth,text width=0.5\textwidth, right]{%
			\@adresseemet%
		};
	
	% Détermination des coordonnées du rectangle, en fonction de l'adresse
	\coordinate[xshift=-1\textwidth,yshift=1ex] (a) at (b.north);
	\coordinate[xshift=1em,yshift=-1ex] (c) at (b.south);
	\draw[color=encadre,line width=1.5mm] (a) rectangle  (c);

%	\draw (b.north west) rectangle (b) ;
	\end{tikzpicture}
		
	
	\vspace{3ex}	
	
	\begin{flushright}	
		
	
	{\Huge\textcolor{entetes}{\textbf\@type}}
	
	\end{flushright}	
	
	\vspace{3ex}	
	
	\begin{tikzpicture}
	

	\ifdef{\@fact}{
	\node[text width=0.33\textwidth,anchor=base]{
		\textcolor{entetes}{\textbf\facturation}
		
		\@fact
		};
	}{}
	
	\node[xshift=0.33\textwidth,text width=0.33\textwidth,anchor=base]{\ifdef{\@fact}{
			\textcolor{entetes}{\textbf\livraison}}
			{\textcolor{entetes}{\textbf\livraisonfacturation}}
			
		\@dest
	};
	\node[text width=0.33\textwidth,xshift=0.66\textwidth,anchor=base]{
		\textcolor{entetes}{\textbf{\datetxt}} \@date	\\
		\ifdef{\@numero}{%
			\textcolor{entetes}{\textbf{\@type\ntxt}} \@numero		
		}{}
		\\
		\ifdef{\@codedest}{%
			\textcolor{entetes}{\textbf{\codeclient}} \@codedest		
		}{}
		\ifdef{\@datelimite}{\\\AdvanceDate[\@datelimite]\textcolor{entetes}{\textbf{\datelimitetxt}} \@date}{}
	};
	
	\end{tikzpicture}
	

}





%%%%%%%%%% Pied de page
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrule}{\relax} % Pour ne pas avoir de trait en haut
\lfoot{\ifnumgreater{\thepage}{1}{\thepage}{}}

%%%%%%%%% Tableau

\xdef\totTVA{}
\xdef\totHT{}
\xdef\totTTC{}
\newenvironment{facture}{%
	\begin{longtable}{|l|l|l|l|l|l|l|}
	\produit & \quantite & \prixHT & \remise & \totalHT & \TVAtxt & \prixTTC \\%
	\endhead
	}{%
	\end{longtable}
	
	\begin{tikzpicture}
	\begin{scope}[xshift=0.66\textwidth]	
		\node{\textcolor{entetes}{\textbf\totHTtxt}  \totHT \unite};
		\node{\textcolor{entetes}{\textbf\totTVAtxt} \totTVA \unite};
		\node{\textcolor{entetes}{\textbf\totTTCtxt} \totTTC \unite};
	\end{scope}
	\end{tikzpicture}
	
	}

\newcommandx{\ligne}[5][2=1,4=\tvadefaut,5=0,usedefault]{%
	% 1:produit
	% 2:QT (optionnel)
	% 3:prix HT
	% 4:TVA (optionnel)
	% 5:Remise (optionnel)
	%#1 & #2 & #3 &  #5 &
	% Prix hors taxe
	\fpMul{\HTprecis}{#3}{#2}%
	\fpSub{\HTprecis}{\HTprecis}{#5}%
	\fpRound{\HT}{\HTprecis}{\arrondi}%arrondissons
	\xdef\HT{\HT}%retenons
	\fpAdd{\totHT}{\totHT}{\HTprecis}
	\xdef\totHT{\totHT}	
	
	
	% Calcul de la TVA
	\fpDiv{\centieme}{#4}{100}%
	\fpMul{\TVAprecis}{\centieme}{\HTprecis}%
	\fpRound{\TVA}{\TVAprecis}{\arrondi}%arrondissons
	\xdef\TVA{\TVA}%retenons
	\fpAdd{\totHT}{\totTVA}{\TVAprecis}
	\xdef\totTVA{\totTVA}		
	
	% Prix TTC
	\fpAdd{\TTCprecis}{\HTprecis}{\TVAprecis}%
	\fpRound{\TTC}{\TTCprecis}{\arrondi}%
	\xdef\TTC{\TTC}
	\fpAdd{\totTTC}{\totTTC}{\TTCprecis}
	\xdef\totTTC{\totTTC}	
	
	% Affichage
	#1 &  #2 &  #3 & #5 & \HT  & \TVA (#4\%) & \TTC \\
	
	
	
}