��          �      |      �  �   �  |  �  -   0  L   ^  H   �     �  A     "   S     v     �     �     �     �     �     �     �               *     8     J  �  [  �   �	  ~  �
  >   f  _   �  _     #   e  H   �  2   �               #     :     N     i     z     �     �     �     �     �     �                                   
                                                    	          
USAGE:
   %s [ options ] file [ files... ]
   Uncompress multiple files to STDOUT

   Options:
   -s  Show the list of supported formats
   -h  Show this help
   -v  More verbosity, to STDERR
 
USAGE:
   %s [ options ] file [ files... ]
   file: compressed file(s) to expand/extract

   Use -- [ ARGUMENTS ] to pass arguments to external programs, eg. some tar options:
   unp fastgl.tgz xmnt.tgz -- -C /tmp

   Options:
   -f Continue even if program availability checks fail or directory collision occurs
   -u Special helper mode.
      For most archive types:
      - create directory <filename without suffix>/
      - extract contents there
      For Debian/Ubuntu packages:
      - extract data.tar.gz after each operation in local directory
      - extract control.tar.gz into control/<package_version_arch>/
   -U Smart mode, acts like -u (see above) if archive contains multiple
      elements but if there is only one file/directory element then it's stored 
      in the current directory.
   -s Show the list of supported formats
   -v More verbosity
   -h Show this help
 Cannot create target %s: file already exists
 Cannot create target %s: file already exists. Trying alternative targets...
 Cannot create target directory (already exists), using alternative name
 Cannot read %s, skipping...
 Error, following packages must be installed in order to proceed:
 Failed to detect file type of %s.
 cpio or afio formail and mpack libchm-bin or archmage p7zip or p7zip-full rar or unrar or unrar-free rpm2cpio and cpio tar with bzip2 tar with compress tar with gzip tar with lzip tar with lzop tar with xz-utils xz-utils or lzma Project-Id-Version: unp
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2012-05-02 22:28-0400
PO-Revision-Date: 2011-03-22 11:03+0100
Last-Translator: Thomas Blein <tblein@tblein.eu>
Language-Team: French <debian-l10n-french@lists.debian.org>
Language: FR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: Lokalize 1.0
Plural-Forms: nplurals=2; plural=(n > 1);
 
UTILISATION :
   %s [ options ] fichier [ fichiers… ]
   Décompresse des fichiers multiples vers STDOUT.

   Options :
   -s  Affiche la liste des formats pris en charge.
   -h  Affiche cette aide.
   -v  Plus de détails, vers STDERR.
 
UTILISATION :
   %s [ options ] fichier [ fichiers… ]
   fichier: fichier(s) compressé(s) à extraire

   Utilisez -- [ ARGUMENTS ] pour passer des arguments aux programmes 
   externes. Par exemple pour des options de tar :
   unp fastgl.tgz xmnt.tgz -- -C /tmp

   Options :
   -f Continue même si la vérification de la présence d'un programme 
      externe échoue ou s'il y a une collision de répertoire.
   -u Mode assisté.
      Pour la plupart des formats d'archive :
         - crée le répertoire <nom de fichier sans suffixe>/
         - y extrait le contenu de l'archive
      Pour les paquets Debian/Ubuntu :
         - extrait data.tar.gz après chaque opération dans le répertoire local
         - extrait control.tar.gz dans le répertoire control/<paquet_version_architecture>/
   -U Mode intelligent, se comporte comme -u (voir ci-dessus) si l'archive 
       contient des éléments multiples. Mais s'il n'y a qu'un seul fichier ou 
       dossier, celui-ci est alors extrait dans le répertoire courant.
   -s Affiche la liste des formats pris en charge.
   -v Affiche plus de détails.
   -h Affiche cette aide.
 Impossible de créer la cible %s : le fichier existe déjà.
 Impossible de créer la cible %s : le fichier existe déjà. Essai de cibles alternatives… 
 Impossible de créer le répertoire cible (il existe déjà), utilisation d'un nom alternatif.
 Impossible de lire %s, ignoré… 
 Erreur, les paquets suivants doivent être installés pour continuer :
 Échec de la détection du type de fichier de %s.
 cpio ou afio formail et mpack libchm-bin ou archmage p7zip ou p7zip-full rar ou unrar ou unrar-free rpm2cpio et cpio tar et bzip2 tar et compress tar et gzip tar et lzip tar et lzop tar et xz-utils tar et lzma 